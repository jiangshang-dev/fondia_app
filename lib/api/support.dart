import 'package:fondia/constants/index.dart';
import 'package:fondia/utils/sse_client.dart';
import 'package:fondia/utils/DioRequest.dart';

class SupportApi {
  static final DioRequest _http = dioRequest;

  static Future<Map<String, dynamic>> getConfig() async {
    final res = await _http.get(HttpConstants.SUPPORT_CONFIG);
    return Map<String, dynamic>.from(res ?? {});
  }

  static Future<List<dynamic>> getFaqList() async {
    final res = await _http.get(HttpConstants.SUPPORT_FAQ_LIST);
    if (res is List) return res;
    return [];
  }

  static Future<List<dynamic>> getQuickEntryList() async {
    final res = await _http.get(HttpConstants.SUPPORT_QUICK_ENTRY_LIST);
    if (res is List) return res;
    return [];
  }

  static Future<Map<String, dynamic>> aiChat({
    required String content,
    String? sessionId,
    String? source,
  }) async {
    String? resultSessionId = sessionId;
    String reply = '';
    List<dynamic> recipes = [];
    var transferred = false;
    String? humanGreeting;

    final accumulator = AiStreamTextAccumulator();

    await aiChatStream(
      content: content,
      sessionId: sessionId,
      source: source,
      onEvent: (event) {
        final eventType = event['event']?.toString() ?? '';
        if (eventType == 'APP_META') {
          resultSessionId = event['sessionId']?.toString() ?? resultSessionId;
          recipes = event['recipes'] is List ? event['recipes'] as List : [];
        } else if (eventType == 'APP_TRANSFER') {
          transferred = true;
          resultSessionId = event['sessionId']?.toString() ?? resultSessionId;
          reply = event['reply']?.toString() ?? '';
          humanGreeting = event['humanGreeting']?.toString();
        } else if (eventType == 'APP_ERROR') {
          throw Exception(event['message']?.toString() ?? 'AI服务异常');
        } else {
          accumulator.consume(event);
        }
      },
    );

    if (!transferred && reply.isEmpty) {
      reply = accumulator.text;
    }

    return {
      'sessionId': resultSessionId,
      'reply': reply,
      'recipes': recipes,
      'transferred': transferred,
      if (humanGreeting != null) 'humanGreeting': humanGreeting,
    };
  }

  /// SSE 流式 AI 对话（与 Airag /airag/chat/send 事件协议一致，末尾追加 APP_META）
  static Future<void> aiChatStream({
    required String content,
    String? sessionId,
    String? source,
    required AiSseCallback onEvent,
  }) async {
    await postSseStream(
      path: HttpConstants.SUPPORT_AI_CHAT,
      body: {
        'content': content,
        if (sessionId != null) 'sessionId': sessionId,
        if (source != null) 'source': source,
      },
      onEvent: onEvent,
    );
  }

  static Future<List<dynamic>> listAiSessions({
    String source = 'ai_tab',
    int pageNo = 1,
    int pageSize = 20,
  }) async {
    final res = await _http.get(
      HttpConstants.SUPPORT_AI_SESSIONS,
      params: {
        'source': source,
        'pageNo': pageNo,
        'pageSize': pageSize,
      },
    );
    if (res is List) return res;
    return [];
  }

  static Future<Map<String, dynamic>?> getActiveAiSession({String source = 'ai_tab'}) async {
    final res = await _http.get(
      HttpConstants.SUPPORT_AI_SESSION_ACTIVE,
      params: {'source': source},
    );
    if (res == null) return null;
    return Map<String, dynamic>.from(res);
  }

  static Future<Map<String, dynamic>> createAiSession({String source = 'ai_tab'}) async {
    final res = await _http.post(
      HttpConstants.SUPPORT_AI_SESSION_NEW,
      params: {'source': source},
    );
    return Map<String, dynamic>.from(res ?? {});
  }

  static Future<Map<String, dynamic>> transferToHuman({String? source}) async {
    final res = await _http.post(
      HttpConstants.SUPPORT_SESSION_TRANSFER,
      data: {if (source != null) 'source': source},
    );
    return Map<String, dynamic>.from(res ?? {});
  }

  static Future<Map<String, dynamic>?> getActiveSession() async {
    final res = await _http.get(HttpConstants.SUPPORT_SESSION_ACTIVE);
    if (res == null) return null;
    return Map<String, dynamic>.from(res);
  }

  static Future<List<dynamic>> getMessages(String sessionId) async {
    final res = await _http.get('${HttpConstants.SUPPORT_SESSION_MESSAGES}/$sessionId/messages');
    if (res is List) return res;
    return [];
  }

  static Future<void> sendHumanMessage(String sessionId, String content) async {
    await _http.post(
      '${HttpConstants.SUPPORT_SESSION_MESSAGES}/$sessionId/message',
      data: {'content': content},
    );
  }

  static Future<void> closeSession(String sessionId) async {
    await _http.post('${HttpConstants.SUPPORT_SESSION_CLOSE}/$sessionId/close');
  }
}
