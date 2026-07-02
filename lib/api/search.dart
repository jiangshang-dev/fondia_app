import 'package:fondia/constants/index.dart';
import 'package:fondia/models/recipe_models.dart';
import 'package:fondia/utils/DioRequest.dart';

class SearchApi {
  static final DioRequest _http = dioRequest;

  static Future<RecipePage> searchRecipes({
    required String keyword,
    int pageNo = 1,
    int pageSize = 20,
  }) async {
    final res = await _http.get(
      HttpConstants.SEARCH_RECIPE,
      params: {
        'keyword': keyword,
        'pageNo': pageNo,
        'pageSize': pageSize,
      },
    );
    if (res is Map<String, dynamic>) {
      return RecipePage.fromJson(res);
    }
    return RecipePage(records: const [], total: 0, current: pageNo);
  }
}
