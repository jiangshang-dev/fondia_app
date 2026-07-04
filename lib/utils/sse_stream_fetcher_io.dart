import 'package:http/http.dart' as http;

/// 移动端 / 桌面端：标准 http 流
Future<Stream<List<int>>> openSsePostStream(
  http.Request request,
) async {
  final client = http.Client();
  final response = await client.send(request);
  if (response.statusCode < 200 || response.statusCode >= 300) {
    client.close();
    final err = await response.stream.bytesToString();
    throw Exception('HTTP ${response.statusCode}: $err');
  }
  return response.stream;
}
