import 'dart:async';

import 'package:http/http.dart' as http;

/// 移动端 / 桌面端：标准 http 流
Future<Stream<List<int>>> openSsePostStream(
  http.Request request,
) async {
  final client = http.Client();
  try {
    final response = await client.send(request);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      final err = await response.stream.bytesToString();
      client.close();
      throw Exception('HTTP ${response.statusCode}: $err');
    }
    // 流结束后关闭 Client；网关 RST 收尾时不当作失败抛出
    return response.stream.transform(
      StreamTransformer.fromHandlers(
        handleData: (data, sink) => sink.add(data),
        handleDone: (sink) {
          client.close();
          sink.close();
        },
        handleError: (error, stackTrace, sink) {
          client.close();
          if (_isBenignSseClose(error)) {
            sink.close();
            return;
          }
          sink.addError(error, stackTrace);
        },
      ),
    );
  } catch (e) {
    client.close();
    rethrow;
  }
}

bool _isBenignSseClose(Object error) {
  final msg = error.toString();
  return msg.contains('ClientConnection closed') ||
      msg.contains('Connection closed while receiving') ||
      msg.contains('Connection prematurely closed') ||
      msg.contains('HttpException: Connection closed');
}
