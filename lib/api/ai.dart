import 'package:fondia/constants/index.dart';
import 'package:fondia/models/ai_chat_models.dart';
import 'package:fondia/utils/DioRequest.dart';
import 'package:fondia/utils/sse_client.dart';

/// AI 助手页接口（网关 /agent/ai/** → jeecg-agent）
class AiApi {
  static final DioRequest _http = dioRequest;

  /// SSE 流式对话
  static Future<void> chatStream({
    required String content,
    String? sessionId,
    String? source,
    required AiSseCallback onEvent,
  }) async {
    await postSseStream(
      path: HttpConstants.AI_CHAT,
      body: {
        'content': content,
        if (sessionId != null) 'sessionId': sessionId,
        if (source != null) 'source': source,
      },
      onEvent: onEvent,
    );
  }

  static Future<List<dynamic>> listSessions({
    String source = kAiTabSource,
    int pageNo = 1,
    int pageSize = 20,
  }) async {
    final res = await _http.get(
      HttpConstants.AI_SESSIONS,
      params: {
        'source': source,
        'pageNo': pageNo,
        'pageSize': pageSize,
      },
    );
    if (res is List) return res;
    return [];
  }

  static Future<Map<String, dynamic>?> getActiveSession({String source = kAiTabSource}) async {
    final res = await _http.get(
      HttpConstants.AI_SESSION_ACTIVE,
      params: {'source': source},
    );
    if (res == null) return null;
    return Map<String, dynamic>.from(res);
  }

  static Future<Map<String, dynamic>> createSession({String source = kAiTabSource}) async {
    final res = await _http.post(
      HttpConstants.AI_SESSION_NEW,
      params: {'source': source},
    );
    return Map<String, dynamic>.from(res ?? {});
  }

  /// 会话历史消息（Redis display_history）
  static Future<List<dynamic>> getMessages(String sessionId) async {
    final res = await _http.get('${HttpConstants.AI_SESSION}/$sessionId/messages');
    if (res is List) return res;
    return [];
  }

  static Future<void> stopChat({required String sessionId}) async {
    await _http.post(
      HttpConstants.AI_CHAT_STOP,
      data: {'sessionId': sessionId},
    );
  }
}
