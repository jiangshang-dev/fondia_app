import 'package:fetch_client/fetch_client.dart';
import 'package:http/http.dart' as http;

/// Web 端：使用浏览器 Fetch API，支持真正的 SSE 流式读取
Future<Stream<List<int>>> openSsePostStream(
  http.Request request,
) async {
  final client = FetchClient(mode: RequestMode.cors);
  final response = await client.send(request);
  if (response.statusCode < 200 || response.statusCode >= 300) {
    client.close();
    final err = await response.stream.bytesToString();
    throw Exception('HTTP ${response.statusCode}: $err');
  }
  return response.stream;
}
