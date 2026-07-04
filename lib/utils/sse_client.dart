import 'dart:async';
import 'dart:convert';

import 'package:fondia/constants/index.dart';
import 'package:fondia/stores/TokenManager.dart';
import 'package:http/http.dart' as http;

import 'sse_stream_fetcher.dart';

typedef AiSseCallback = void Function(Map<String, dynamic> event);

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

  final byteStream = await openSsePostStream(request).timeout(const Duration(minutes: 5));
  await _consumeSseStream(byteStream, onEvent);
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

/// 从 Airag SSE 事件累积展示文本（与 jeecgboot-vue3 chat.vue renderText 逻辑对齐）
class AiStreamTextAccumulator {
  String text = '';
  bool _thinking = false;

  void consume(Map<String, dynamic> event) {
    final eventType = event['event']?.toString() ?? '';
    if (eventType == 'THINKING') {
      _thinking = true;
      return;
    }
    if (eventType != 'MESSAGE') {
      return;
    }
    final data = event['data'];
    if (data is! Map) return;
    final message = data['message']?.toString() ?? '';
    if (message.isEmpty) return;

    if (_thinking) {
      text = message;
      _thinking = false;
    } else {
      text += message;
    }
  }
}
