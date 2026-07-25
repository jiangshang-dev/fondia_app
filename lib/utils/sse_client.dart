import 'dart:async';
import 'dart:convert';

import 'package:fondia/constants/index.dart';
import 'package:fondia/stores/TokenManager.dart';
import 'package:http/http.dart' as http;

import 'sse_stream_fetcher.dart';

typedef AiSseCallback = void Function(Map<String, dynamic> event);

/// 网关转发 SSE 结束时常见的“半关闭”异常，视为正常结束。
bool isBenignSseClose(Object error) {
  final msg = error.toString();
  return msg.contains('ClientConnection closed') ||
      msg.contains('Connection closed while receiving') ||
      msg.contains('Connection prematurely closed') ||
      msg.contains('HttpException: Connection closed');
}

/// 与 JeecgBoot Airag SSE 协议一致的流式 POST 客户端
Future<void> postSseStream({
  required String path,
  required Map<String, dynamic> body,
  required AiSseCallback onEvent,
}) async {
  final uri = Uri.parse('${GlobalConstants.BASE_URL}$path');
  final request = http.Request('POST', uri);
  request.headers['Accept'] = 'text/event-stream';
  request.headers['Content-Type'] = 'application/json; charset=UTF-8';
  request.headers['Cache-Control'] = 'no-cache';

  final token = tokenManager.getToken();
  if (token.isNotEmpty) {
    request.headers['Authorization'] = 'Bearer $token';
  }
  request.body = jsonEncode(body);

  try {
    final byteStream =
        await openSsePostStream(request).timeout(const Duration(minutes: 5));
    await _consumeSseStream(byteStream, onEvent);
  } catch (e) {
    // Spring Cloud Gateway 在上游 SseEmitter.complete() 后常会 RST 连接，
    // Dart http 表现为 ClientConnection closed；正文已收完，按正常结束处理。
    if (isBenignSseClose(e)) {
      return;
    }
    rethrow;
  }
}

Future<void> _consumeSseStream(
  Stream<List<int>> byteStream,
  AiSseCallback onEvent,
) async {
  var lineBuffer = '';
  await for (final chunk in byteStream.transform(utf8.decoder)) {
    lineBuffer += chunk;
    while (true) {
      final lineEnd = lineBuffer.indexOf('\n');
      if (lineEnd < 0) break;

      var line = lineBuffer.substring(0, lineEnd);
      lineBuffer = lineBuffer.substring(lineEnd + 1);
      line = line.trim();
      if (line.isEmpty) continue;

      if (line.startsWith('data:')) {
        _emitPayload(line.substring(5).trim(), onEvent);
      } else if (line.startsWith('{')) {
        _emitPayload(line, onEvent);
      }
    }
  }

  final tail = lineBuffer.trim();
  if (tail.startsWith('data:')) {
    _emitPayload(tail.substring(5).trim(), onEvent);
  } else if (tail.startsWith('{')) {
    _emitPayload(tail, onEvent);
  }
}

void _emitPayload(String payload, AiSseCallback onEvent) {
  if (payload.isEmpty || payload == '[DONE]') return;
  try {
    final decoded = jsonDecode(payload);
    if (decoded is Map) {
      onEvent(Map<String, dynamic>.from(decoded));
    }
  } catch (_) {}
}

/// 从 Airag SSE 事件累积展示文本。
/// 与 Support [CsAiServiceImpl.appendMessageFromEvent] 一致：MESSAGE 只追加，绝不重置。
/// 勿照搬 Vue chat.vue 中「THINKING 后首条 MESSAGE 重置 text」逻辑，否则工具调用前已输出段落会被清掉。
class AiStreamTextAccumulator {
  String text = '';

  void consume(Map<String, dynamic> event) {
    final eventType = event['event']?.toString() ?? '';
    if (eventType != 'MESSAGE') {
      return;
    }

    final message = _readMessage(event);
    if (message == null || message.isEmpty) return;

    if (message.contains('::jeecgToolExec::') ||
        message.contains('::card::') ||
        message.contains('::cardConfig::')) {
      return;
    }

    text += message;
  }

  static String? _readMessage(Map<String, dynamic> event) {
    final raw = event['data'];
    dynamic data = raw;
    if (raw is String) {
      final trimmed = raw.trim();
      if (trimmed.startsWith('{')) {
        try {
          final parsed = jsonDecode(trimmed);
          if (parsed is Map) {
            data = parsed;
          }
        } catch (_) {
          return raw;
        }
      } else if (trimmed.isNotEmpty) {
        return raw;
      }
    }
    if (data is Map) {
      final msg = data['message'] ?? data['content'];
      return msg?.toString();
    }
    return null;
  }
}
