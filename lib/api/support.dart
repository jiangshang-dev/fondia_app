import 'package:fondia/constants/index.dart';
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
    final res = await _http.post(
      HttpConstants.SUPPORT_AI_CHAT,
      data: {
        'content': content,
        if (sessionId != null) 'sessionId': sessionId,
        if (source != null) 'source': source,
      },
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
