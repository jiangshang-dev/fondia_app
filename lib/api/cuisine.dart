import 'package:fondia/constants/index.dart';
import 'package:fondia/models/recipe_models.dart';
import 'package:fondia/utils/DioRequest.dart';

/// 菜谱/菜品接口
class CuisineApi {
  static final DioRequest _http = dioRequest;

  /// 热门菜系
  static Future<List<CategoryBrief>> listHotCuisines() async {
    final result = await _http.get(HttpConstants.CUISINE_CATEGORY_HOT);
    return _parseList(result, CategoryBrief.fromJson);
  }

  /// 全部菜系
  static Future<List<CategoryBrief>> listAllCuisines() async {
    final result = await _http.get(HttpConstants.CUISINE_CATEGORY_LIST);
    return _parseList(result, CategoryBrief.fromJson);
  }

  /// 菜系详情
  static Future<CuisineDetail> getCuisineDetail(int cuisineId) async {
    final result =
        await _http.get('${HttpConstants.CUISINE_CATEGORY}/$cuisineId');
    return CuisineDetail.fromJson(result as Map<String, dynamic>);
  }

  /// 分类页树（主食/菜 + 菜谱）
  static Future<CategoryTree> getCategoryTree(int cuisineId) async {
    final result =
        await _http.get('${HttpConstants.CUISINE_CATEGORY}/$cuisineId/tree');
    return CategoryTree.fromJson(result as Map<String, dynamic>);
  }

  /// 菜谱分页列表
  static Future<RecipePage> pageRecipes({
    int? cuisineId,
    int? categoryId,
    int? subType,
    int? tagId,
    String? keyword,
    int pageNo = 1,
    int pageSize = 10,
  }) async {
    final params = <String, dynamic>{
      'pageNo': pageNo,
      'pageSize': pageSize,
    };
    if (cuisineId != null) params['cuisineId'] = cuisineId;
    if (categoryId != null) params['categoryId'] = categoryId;
    if (subType != null) params['subType'] = subType;
    if (tagId != null) params['tagId'] = tagId;
    if (keyword != null && keyword.isNotEmpty) params['keyword'] = keyword;

    final result =
        await _http.get(HttpConstants.CUISINE_RECIPE_LIST, params: params);
    return RecipePage.fromJson(result as Map<String, dynamic>);
  }

  /// 菜谱详情
  static Future<RecipeDetail> getRecipeDetail(String recipeId) async {
    final result =
        await _http.get('${HttpConstants.CUISINE_RECIPE}/$recipeId');
    return RecipeDetail.fromJson(result as Map<String, dynamic>);
  }

  /// 增加浏览量
  static Future<void> incrementView(String recipeId) async {
    await _http.post('${HttpConstants.CUISINE_RECIPE}/$recipeId/view');
  }

  /// 解析阿里云 VOD 视频播放地址（兜底）
  static Future<String?> resolveVideoPlayUrl(String videoId) async {
    if (videoId.isEmpty) return null;
    final result = await _http.get(
      HttpConstants.CUISINE_RECIPE_VIDEO_PLAY,
      params: {'videoId': videoId},
    );
    if (result is Map<String, dynamic>) {
      return result['playUrl']?.toString();
    }
    return null;
  }

  static List<T> _parseList<T>(
    dynamic result,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    if (result is! List) return [];
    return result
        .map((e) => fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
