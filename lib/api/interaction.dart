import 'package:fondia/api/cuisine.dart';
import 'package:fondia/constants/index.dart';
import 'package:fondia/models/comment_models.dart';
import 'package:fondia/models/interaction_models.dart';
import 'package:fondia/models/recipe_models.dart';
import 'package:fondia/utils/DioRequest.dart';

class InteractionApi {
  static final DioRequest _http = dioRequest;

  // ---------- 收藏 / 点赞 / 浏览 ----------

  static Future<InteractionRecordPage> getMyCollects({
    int pageNo = 1,
    int pageSize = 20,
  }) async {
    final result = await _http.get(
      HttpConstants.INTERACTION_COLLECT_MY,
      params: {'pageNo': pageNo, 'pageSize': pageSize},
    );
    return InteractionRecordPage.fromJson(result as Map<String, dynamic>);
  }

  static Future<InteractionRecordPage> getMyLikes({
    int pageNo = 1,
    int pageSize = 20,
  }) async {
    final result = await _http.get(
      HttpConstants.INTERACTION_LIKE_MY,
      params: {'pageNo': pageNo, 'pageSize': pageSize},
    );
    return InteractionRecordPage.fromJson(result as Map<String, dynamic>);
  }

  static Future<InteractionRecordPage> getMyBrowseHistory({
    int pageNo = 1,
    int pageSize = 20,
  }) async {
    final result = await _http.get(
      HttpConstants.INTERACTION_BROWSE_MY,
      params: {'pageNo': pageNo, 'pageSize': pageSize},
    );
    return InteractionRecordPage.fromJson(result as Map<String, dynamic>);
  }

  static Future<int> getMyCollectCount() async {
    final page = await getMyCollects(pageNo: 1, pageSize: 1);
    return page.total;
  }

  static Future<int> getMyLikeCount() async {
    final page = await getMyLikes(pageNo: 1, pageSize: 1);
    return page.total;
  }

  static Future<int> getMyBrowseCount() async {
    final page = await getMyBrowseHistory(pageNo: 1, pageSize: 1);
    return page.total;
  }

  static Future<ToggleInteractionResult> toggleCollect(String recipeId) async {
    final result = await _http.post(
      HttpConstants.INTERACTION_COLLECT_TOGGLE,
      data: {'recipeId': recipeId},
    );
    return ToggleInteractionResult.fromJson(result as Map<String, dynamic>);
  }

  static Future<ToggleInteractionResult> toggleLike(String recipeId) async {
    final result = await _http.post(
      HttpConstants.INTERACTION_LIKE_TOGGLE,
      data: {'recipeId': recipeId},
    );
    return ToggleInteractionResult.fromJson(result as Map<String, dynamic>);
  }

  static Future<bool> isLiked(String recipeId) async {
    final result = await _http.get(
      HttpConstants.INTERACTION_LIKE_STATUS,
      params: {'recipeId': recipeId},
    );
    return result == true;
  }

  static Future<bool> isCollected(String recipeId) async {
    final result = await _http.get(
      HttpConstants.INTERACTION_COLLECT_STATUS,
      params: {'recipeId': recipeId},
    );
    return result == true;
  }

  static Future<void> recordBrowse(String recipeId) async {
    await _http.post(
      HttpConstants.INTERACTION_BROWSE_RECORD,
      data: {'recipeId': recipeId},
    );
  }

  static Future<MineRecipePage> loadMineRecipes(
    Future<InteractionRecordPage> Function({int pageNo, int pageSize}) fetchPage, {
    int pageNo = 1,
    int pageSize = 20,
  }) async {
    final page = await fetchPage(pageNo: pageNo, pageSize: pageSize);
    final items = await Future.wait(
      page.records.map((record) => _enrichRecord(record)),
    );
    return MineRecipePage(items: items, total: page.total);
  }

  static Future<MineRecipeItem> _enrichRecord(InteractionRecord record) async {
    try {
      final RecipeDetail detail = await CuisineApi.getRecipeDetail(record.recipeId);
      return MineRecipeItem(
        recipeId: record.recipeId,
        title: detail.title,
        subtitle: detail.subtitle,
        coverImage: detail.coverImage,
        viewCount: detail.viewCount,
        likeCount: detail.likeCount,
        actionTime: record.actionTime,
        tags: detail.tags,
      );
    } catch (_) {
      return MineRecipeItem(
        recipeId: record.recipeId,
        title: '菜谱 #${record.recipeId}',
        actionTime: record.actionTime,
      );
    }
  }

  // ---------- 评论 ----------

  static Future<CommentTreePage> getCommentTree(
    String recipeId, {
    int pageNo = 1,
    int pageSize = 20,
  }) async {
    final result = await _http.get(
      HttpConstants.INTERACTION_COMMENT_TREE,
      params: {
        'recipeId': recipeId,
        'pageNo': pageNo,
        'pageSize': pageSize,
      },
    );
    return CommentTreePage.fromJson(result as Map<String, dynamic>);
  }

  static Future<CommentItem> addComment(String recipeId, String content) async {
    final result = await _http.post(
      HttpConstants.INTERACTION_COMMENT_ADD,
      data: {'recipeId': recipeId, 'content': content},
    );
    return CommentItem.fromJson(result as Map<String, dynamic>);
  }

  static Future<CommentItem> replyComment(String parentId, String content) async {
    final result = await _http.post(
      HttpConstants.INTERACTION_COMMENT_REPLY,
      data: {'parentId': parentId, 'content': content},
    );
    return CommentItem.fromJson(result as Map<String, dynamic>);
  }

  static Future<CommentReactionResult> toggleReaction(
    String commentId,
    int reactionType,
  ) async {
    final result = await _http.post(
      HttpConstants.INTERACTION_COMMENT_REACTION,
      data: {'commentId': commentId, 'reactionType': reactionType},
    );
    return CommentReactionResult.fromJson(result as Map<String, dynamic>);
  }

  static Future<void> deleteComment(String commentId) async {
    await _http.delete('${HttpConstants.INTERACTION_COMMENT}/$commentId');
  }
}
