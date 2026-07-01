import 'package:fondia/utils/id_util.dart';

class CommentItem {
  final String id;
  final String recipeId;
  final String userId;
  final String parentId;
  final String rootId;
  final String? replyUserId;
  final String content;
  final int likeCount;
  final int dislikeCount;
  final int replyCount;
  final int status;
  final String statusLabel;
  final String nickname;
  final String? avatar;
  final String? replyUserNickname;
  final int? myReaction;
  final bool mine;
  final String? createTime;
  final List<CommentItem> replies;

  const CommentItem({
    required this.id,
    required this.recipeId,
    required this.userId,
    required this.parentId,
    required this.rootId,
    this.replyUserId,
    required this.content,
    this.likeCount = 0,
    this.dislikeCount = 0,
    this.replyCount = 0,
    this.status = 1,
    this.statusLabel = '已发布',
    required this.nickname,
    this.avatar,
    this.replyUserNickname,
    this.myReaction,
    this.mine = false,
    this.createTime,
    this.replies = const [],
  });

  bool get isPublished => status == 1;
  bool get isAuditing => status == 2;
  bool get isHidden => status == 0;

  CommentItem copyWith({
    int? likeCount,
    int? dislikeCount,
    int? myReaction,
    bool clearReaction = false,
    List<CommentItem>? replies,
  }) {
    return CommentItem(
      id: id,
      recipeId: recipeId,
      userId: userId,
      parentId: parentId,
      rootId: rootId,
      replyUserId: replyUserId,
      content: content,
      likeCount: likeCount ?? this.likeCount,
      dislikeCount: dislikeCount ?? this.dislikeCount,
      replyCount: replyCount,
      status: status,
      statusLabel: statusLabel,
      nickname: nickname,
      avatar: avatar,
      replyUserNickname: replyUserNickname,
      myReaction: clearReaction ? null : (myReaction ?? this.myReaction),
      mine: mine,
      createTime: createTime,
      replies: replies ?? this.replies,
    );
  }

  factory CommentItem.fromJson(Map<String, dynamic> json) {
    final repliesJson = json['replies'];
    return CommentItem(
      id: asIdString(json['id']),
      recipeId: asIdString(json['recipeId']),
      userId: asIdString(json['userId']),
      parentId: asIdString(json['parentId']),
      rootId: asIdString(json['rootId']),
      replyUserId: json['replyUserId'] == null ? null : asIdString(json['replyUserId']),
      content: json['content']?.toString() ?? '',
      likeCount: _asInt(json['likeCount']),
      dislikeCount: _asInt(json['dislikeCount']),
      replyCount: _asInt(json['replyCount']),
      status: _asInt(json['status'], defaultValue: 1),
      statusLabel: json['statusLabel']?.toString() ?? '已发布',
      nickname: json['nickname']?.toString() ?? '用户',
      avatar: json['avatar']?.toString(),
      replyUserNickname: json['replyUserNickname']?.toString(),
      myReaction: json['myReaction'] == null ? null : _asInt(json['myReaction']),
      mine: json['mine'] == true,
      createTime: json['createTime']?.toString(),
      replies: repliesJson is List
          ? repliesJson
              .whereType<Map>()
              .map((e) => CommentItem.fromJson(Map<String, dynamic>.from(e)))
              .toList()
          : const [],
    );
  }
}

class CommentTreePage {
  final List<CommentItem> records;
  final int total;

  const CommentTreePage({required this.records, this.total = 0});

  factory CommentTreePage.fromJson(Map<String, dynamic> json) {
    final recordsJson = json['records'];
    return CommentTreePage(
      records: recordsJson is List
          ? recordsJson
              .whereType<Map>()
              .map((e) => CommentItem.fromJson(Map<String, dynamic>.from(e)))
              .toList()
          : const [],
      total: _asInt(json['total']),
    );
  }
}

class CommentReactionResult {
  final String commentId;
  final int likeCount;
  final int dislikeCount;
  final int? myReaction;

  const CommentReactionResult({
    required this.commentId,
    required this.likeCount,
    required this.dislikeCount,
    this.myReaction,
  });

  factory CommentReactionResult.fromJson(Map<String, dynamic> json) {
    return CommentReactionResult(
      commentId: asIdString(json['commentId']),
      likeCount: _asInt(json['likeCount']),
      dislikeCount: _asInt(json['dislikeCount']),
      myReaction: json['myReaction'] == null ? null : _asInt(json['myReaction']),
    );
  }
}

int _asInt(dynamic value, {int defaultValue = 0}) {
  if (value == null) return defaultValue;
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value.toString()) ?? defaultValue;
}
