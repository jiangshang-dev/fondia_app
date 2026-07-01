import 'package:fondia/constants/index.dart';
import 'package:fondia/models/comment_models.dart';
import 'package:fondia/utils/DioRequest.dart';

class InteractionApi {
  static final DioRequest _http = dioRequest;

  static Future<CommentTreePage> getCommentTree(
    int recipeId, {
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

  static Future<CommentItem> addComment(int recipeId, String content) async {
    final result = await _http.post(
      HttpConstants.INTERACTION_COMMENT_ADD,
      data: {'recipeId': recipeId, 'content': content},
    );
    return CommentItem.fromJson(result as Map<String, dynamic>);
  }

  static Future<CommentItem> replyComment(int parentId, String content) async {
    final result = await _http.post(
      HttpConstants.INTERACTION_COMMENT_REPLY,
      data: {'parentId': parentId, 'content': content},
    );
    return CommentItem.fromJson(result as Map<String, dynamic>);
  }

  static Future<CommentReactionResult> toggleReaction(
    int commentId,
    int reactionType,
  ) async {
    final result = await _http.post(
      HttpConstants.INTERACTION_COMMENT_REACTION,
      data: {'commentId': commentId, 'reactionType': reactionType},
    );
    return CommentReactionResult.fromJson(result as Map<String, dynamic>);
  }

  static Future<void> deleteComment(int commentId) async {
    await _http.delete('${HttpConstants.INTERACTION_COMMENT}/${commentId}');
  }
}
