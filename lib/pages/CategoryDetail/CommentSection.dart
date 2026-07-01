import 'package:flutter/material.dart';
import 'package:fondia/api/interaction.dart';
import 'package:fondia/models/comment_models.dart';
import 'package:fondia/stores/TokenManager.dart';

class CommentSection extends StatefulWidget {
  final String recipeId;
  final int? commentCount;

  const CommentSection({
    super.key,
    required this.recipeId,
    this.commentCount,
  });

  @override
  State<CommentSection> createState() => _CommentSectionState();
}

class _CommentSectionState extends State<CommentSection> {
  final TextEditingController _inputController = TextEditingController();
  final FocusNode _inputFocus = FocusNode();

  List<CommentItem> _comments = [];
  int _total = 0;
  bool _loading = true;
  bool _submitting = false;
  String? _error;
  String? _replyToCommentId;
  String? _replyToNickname;

  @override
  void initState() {
    super.initState();
    _loadComments();
  }

  @override
  void dispose() {
    _inputController.dispose();
    _inputFocus.dispose();
    super.dispose();
  }

  Future<void> _loadComments() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final page = await InteractionApi.getCommentTree(widget.recipeId);
      if (!mounted) return;
      setState(() {
        _comments = page.records;
        _total = page.total;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  void _startReply(CommentItem comment) {
    if (!tokenManager.isLoggedIn()) {
      _goLogin();
      return;
    }
    setState(() {
      _replyToCommentId = comment.id;
      _replyToNickname = comment.nickname;
    });
    _inputFocus.requestFocus();
  }

  void _cancelReply() {
    setState(() {
      _replyToCommentId = null;
      _replyToNickname = null;
    });
  }

  Future<void> _submit() async {
    final content = _inputController.text.trim();
    if (content.isEmpty) return;
    if (!tokenManager.isLoggedIn()) {
      _goLogin();
      return;
    }

    setState(() => _submitting = true);
    try {
      if (_replyToCommentId != null) {
        await InteractionApi.replyComment(_replyToCommentId!, content);
      } else {
        await InteractionApi.addComment(widget.recipeId, content);
      }
      _inputController.clear();
      _cancelReply();
      await _loadComments();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  Future<void> _toggleReaction(CommentItem comment, int reactionType) async {
    if (!tokenManager.isLoggedIn()) {
      _goLogin();
      return;
    }
    if (!comment.isPublished) return;

    try {
      final result =
          await InteractionApi.toggleReaction(comment.id, reactionType);
      if (!mounted) return;
      setState(() {
        _comments = _updateReactionInTree(_comments, result);
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    }
  }

  List<CommentItem> _updateReactionInTree(
    List<CommentItem> list,
    CommentReactionResult result,
  ) {
    return list.map((item) {
      if (item.id == result.commentId) {
        return item.copyWith(
          likeCount: result.likeCount,
          dislikeCount: result.dislikeCount,
          myReaction: result.myReaction,
          clearReaction: result.myReaction == null,
        );
      }
      if (item.replies.isNotEmpty) {
        return item.copyWith(
          replies: _updateReactionInTree(item.replies, result),
        );
      }
      return item;
    }).toList();
  }

  void _goLogin() {
    Navigator.pushNamed(context, '/login');
  }

  int get _displayCount {
    if (_total > 0) return _total;
    return widget.commentCount ?? _comments.length;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      color: const Color(0xFFFAFAFA),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '评论 (${_displayCount})',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          if (_replyToNickname != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Text('回复 @$_replyToNickname',
                      style: const TextStyle(color: Colors.orange, fontSize: 13)),
                  const Spacer(),
                  GestureDetector(
                    onTap: _cancelReply,
                    child: const Text('取消', style: TextStyle(color: Colors.grey)),
                  ),
                ],
              ),
            ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _inputController,
                  focusNode: _inputFocus,
                  maxLines: 3,
                  minLines: 1,
                  decoration: InputDecoration(
                    hintText: tokenManager.isLoggedIn()
                        ? '发表评论...'
                        : '登录后发表评论',
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: _submitting ? null : _submit,
                child: _submitting
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text(
                        '发送',
                        style: TextStyle(
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (_loading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: CircularProgressIndicator(color: Colors.orange),
              ),
            )
          else if (_error != null)
            Center(
              child: Column(
                children: [
                  Text(_error!, style: const TextStyle(color: Colors.grey)),
                  TextButton(onPressed: _loadComments, child: const Text('重试')),
                ],
              ),
            )
          else if (_comments.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Text('暂无评论，快来抢沙发吧~',
                    style: TextStyle(color: Colors.grey)),
              ),
            )
          else
            ..._comments.map((c) => _buildCommentTile(c, depth: 0)),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildCommentTile(CommentItem comment, {required int depth}) {
    final leftPad = depth * 16.0;
    return Padding(
      padding: EdgeInsets.only(left: leftPad, bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: Colors.orange.shade100,
                backgroundImage: comment.avatar != null && comment.avatar!.isNotEmpty
                    ? NetworkImage(comment.avatar!)
                    : null,
                child: comment.avatar == null || comment.avatar!.isEmpty
                    ? Text(comment.nickname.isNotEmpty ? comment.nickname[0] : '?',
                        style: const TextStyle(fontSize: 12))
                    : null,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(comment.nickname,
                            style: const TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 13)),
                        if (!comment.isPublished) ...[
                          const SizedBox(width: 6),
                          _buildStatusTag(comment),
                        ],
                      ],
                    ),
                    if (comment.replyUserNickname != null &&
                        comment.replyUserNickname!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          '回复 @${comment.replyUserNickname}',
                          style: TextStyle(color: Colors.grey[600], fontSize: 12),
                        ),
                      ),
                    const SizedBox(height: 4),
                    Text(comment.content,
                        style: const TextStyle(fontSize: 14, height: 1.4)),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        if (comment.createTime != null)
                          Text(
                            comment.createTime!.length > 16
                                ? comment.createTime!.substring(0, 16)
                                : comment.createTime!,
                            style: TextStyle(color: Colors.grey[500], fontSize: 11),
                          ),
                        const SizedBox(width: 12),
                        GestureDetector(
                          onTap: () => _startReply(comment),
                          child: Text('回复',
                              style: TextStyle(
                                  color: Colors.grey[600], fontSize: 12)),
                        ),
                        const Spacer(),
                        _buildReactionButton(
                          icon: comment.myReaction == 1
                              ? Icons.thumb_up
                              : Icons.thumb_up_outlined,
                          count: comment.likeCount,
                          active: comment.myReaction == 1,
                          enabled: comment.isPublished,
                          onTap: () => _toggleReaction(comment, 1),
                        ),
                        const SizedBox(width: 12),
                        _buildReactionButton(
                          icon: comment.myReaction == 2
                              ? Icons.thumb_down
                              : Icons.thumb_down_outlined,
                          count: comment.dislikeCount,
                          active: comment.myReaction == 2,
                          enabled: comment.isPublished,
                          onTap: () => _toggleReaction(comment, 2),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (comment.replies.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Column(
                children: comment.replies
                    .map((r) => _buildCommentTile(r, depth: depth + 1))
                    .toList(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatusTag(CommentItem comment) {
    Color color;
    if (comment.isAuditing) {
      color = Colors.orange;
    } else if (comment.isHidden) {
      color = Colors.red;
    } else {
      color = Colors.grey;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        comment.isAuditing ? '审核中，仅自己可见' : comment.statusLabel,
        style: TextStyle(color: color, fontSize: 10),
      ),
    );
  }

  Widget _buildReactionButton({
    required IconData icon,
    required int count,
    required bool active,
    required bool enabled,
    required VoidCallback onTap,
  }) {
    final color = !enabled
        ? Colors.grey.shade300
        : active
            ? Colors.orange
            : Colors.grey;
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          if (count > 0) ...[
            const SizedBox(width: 2),
            Text('$count', style: TextStyle(fontSize: 11, color: color)),
          ],
        ],
      ),
    );
  }
}
