import 'package:fondia/constants/index.dart';
import 'package:fondia/utils/DioRequest.dart';

class AiQuotaApi {
  static final DioRequest _http = dioRequest;

  static const String featureNutrition = 'AI_NUTRITION';

  static Future<Map<String, dynamic>> getStatus({String feature = featureNutrition}) async {
    final result = await _http.get(
      HttpConstants.MEMBER_AI_QUOTA_STATUS,
      params: {'feature': feature},
    );
    return Map<String, dynamic>.from(result ?? {});
  }

  static Future<Map<String, dynamic>> consume({String feature = featureNutrition}) async {
    final result = await _http.post(
      HttpConstants.MEMBER_AI_QUOTA_CONSUME,
      params: {'feature': feature},
    );
    return Map<String, dynamic>.from(result ?? {});
  }
}
