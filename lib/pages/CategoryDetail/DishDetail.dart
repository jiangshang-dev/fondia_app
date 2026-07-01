
import 'package:flutter/material.dart';
import 'package:fondia/api/cuisine.dart';
import 'package:fondia/api/interaction.dart';
import 'package:fondia/models/recipe_models.dart';
import 'package:fondia/pages/CategoryDetail/CommentSection.dart';
import 'package:fondia/stores/TokenManager.dart';
import 'package:fondia/utils/recipe_image.dart';

class DishDetail extends StatefulWidget {
  final int recipeId;

  const DishDetail({super.key, required this.recipeId});

  @override
  State<DishDetail> createState() => _DishDetailState();
}

class _DishDetailState extends State<DishDetail> {
  RecipeDetail? _detail;
  bool _loading = true;
  String? _error;
  bool _isLiked = false;
  bool _isCollected = false;
  int _likeCount = 0;
  bool _togglingLike = false;
  bool _togglingCollect = false;

  @override
  void initState() {
    super.initState();
    _loadDetail();
  }

  Future<void> _loadDetail() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final detail = await CuisineApi.getRecipeDetail(widget.recipeId);
      CuisineApi.incrementView(widget.recipeId).catchError((_) {});
      if (tokenManager.isLoggedIn()) {
        InteractionApi.recordBrowse(widget.recipeId).catchError((_) {});
      }
      if (!mounted) return;
      setState(() {
        _detail = detail;
        _likeCount = detail.likeCount ?? 0;
        _loading = false;
      });
      _loadInteractionState();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  Future<void> _loadInteractionState() async {
    if (!tokenManager.isLoggedIn()) return;
    try {
      final results = await Future.wait([
        InteractionApi.isLiked(widget.recipeId),
        InteractionApi.isCollected(widget.recipeId),
      ]);
      if (!mounted) return;
      setState(() {
        _isLiked = results[0];
        _isCollected = results[1];
      });
    } catch (_) {}
  }

  Future<void> _requireLogin() async {
    if (tokenManager.isLoggedIn()) return;
    if (!mounted) return;
    final goLogin = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('提示'),
        content: const Text('请先登录后再操作'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('取消')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('去登录')),
        ],
      ),
    );
    if (goLogin == true && mounted) {
      await Navigator.pushNamed(context, '/login');
      await _loadInteractionState();
    }
  }

  Future<void> _toggleLike() async {
    if (!tokenManager.isLoggedIn()) {
      await _requireLogin();
      return;
    }
    if (_togglingLike) return;
    setState(() => _togglingLike = true);
    try {
      final result = await InteractionApi.toggleLike(widget.recipeId);
      if (!mounted) return;
      setState(() {
        _isLiked = result.active;
        _likeCount = result.count;
      });
    } catch (e) {
      if (!mounted) return;
      await _loadInteractionState();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    } finally {
      if (mounted) setState(() => _togglingLike = false);
    }
  }

  Future<void> _toggleCollect() async {
    if (!tokenManager.isLoggedIn()) {
      await _requireLogin();
      return;
    }
    if (_togglingCollect) return;
    setState(() => _togglingCollect = true);
    try {
      final result = await InteractionApi.toggleCollect(widget.recipeId);
      if (!mounted) return;
      setState(() {
        _isCollected = result.active;
      });
      if (result.active) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('收藏成功')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      await _loadInteractionState();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    } finally {
      if (mounted) setState(() => _togglingCollect = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator(color: Colors.orange)),
      );
    }

    if (_detail == null) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(backgroundColor: Colors.white, elevation: 0),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(_error ?? '加载失败'),
              TextButton(onPressed: _loadDetail, child: const Text('重试')),
            ],
          ),
        ),
      );
    }

    final detail = _detail!;

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildVideoPlayer(context, detail)),
          SliverToBoxAdapter(child: _buildTitleSection(detail)),
          SliverToBoxAdapter(child: _buildInfoBar(detail)),
          const SliverToBoxAdapter(
            child: Divider(height: 1, thickness: 1, color: Color(0xFFF5F5F5)),
          ),
          SliverToBoxAdapter(child: _buildIngredientsSection(detail)),
          const SliverToBoxAdapter(
            child: Divider(height: 1, thickness: 1, color: Color(0xFFF5F5F5)),
          ),
          SliverToBoxAdapter(child: _buildStepsSection(detail)),
          SliverToBoxAdapter(
            child: CommentSection(
              recipeId: widget.recipeId,
              commentCount: detail.commentCount,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoPlayer(BuildContext context, RecipeDetail detail) {
    final width = MediaQuery.of(context).size.width;
    final headerHeight = width * 10 / 16;

    return SizedBox(
      width: width,
      height: headerHeight,
      child: Stack(
        fit: StackFit.expand,
        children: [
          RecipeImage(url: detail.coverImage, fit: BoxFit.cover),
          if (detail.videoUrl != null && detail.videoUrl!.isNotEmpty)
            Container(
              color: Colors.black.withValues(alpha: 0.1),
              alignment: Alignment.center,
              child: const Icon(Icons.play_circle_fill,
                  color: Colors.white, size: 64),
            ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 8,
            right: 8,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: _togglingCollect ? null : _toggleCollect,
                      child: Row(
                        children: [
                          Icon(
                            _isCollected ? Icons.star : Icons.star_border,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _isCollected ? '已收藏' : '收藏',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Icon(Icons.share, color: Colors.white),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            right: 16,
            top: headerHeight * 0.35,
            child: Column(
              children: [
                _buildVideoSideAction(
                  _isLiked ? Icons.favorite : Icons.favorite_border,
                  formatCount(_likeCount),
                  onTap: _toggleLike,
                ),
                _buildVideoSideAction(
                  Icons.message,
                  formatCount(detail.commentCount),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoSideAction(
    IconData icon,
    String label, {
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            Icon(icon, color: Colors.white, size: 28),
            Text(label,
                style: const TextStyle(color: Colors.white, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleSection(RecipeDetail detail) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(detail.title,
              style:
                  const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(detail.subtitle ?? '',
              style: const TextStyle(fontSize: 14, color: Colors.grey)),
          if (detail.description != null && detail.description!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(detail.description!,
                style: const TextStyle(fontSize: 14, color: Color(0xFF666666),
                    height: 1.5)),
          ],
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: detail.tags
                .map((tag) => Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(tag,
                          style: const TextStyle(
                              fontSize: 12, color: Colors.grey)),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBar(RecipeDetail detail) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
      child: Row(
        children: [
          Expanded(
            child: _buildInfoItem(Icons.access_time,
                '${detail.cookMinutes ?? '-'}分钟', '烹饪时间'),
          ),
          Expanded(
            child: _buildInfoItem(Icons.bar_chart,
                difficultyLabel(detail.difficulty), '难度'),
          ),
          Expanded(
            child: _buildInfoItem(
              Icons.local_fire_department,
              detail.calories != null ? '${detail.calories}大卡' : '-',
              '每100克',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String top, String bottom) {
    return Column(
      children: [
        Icon(icon, size: 18, color: Colors.orange),
        const SizedBox(height: 6),
        Text(
          top,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Text(bottom,
            style: const TextStyle(fontSize: 11, color: Colors.grey),
            textAlign: TextAlign.center),
      ],
    );
  }

  Widget _buildIngredientsSection(RecipeDetail detail) {
    final items = detail.ingredients;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('食材准备',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text(detail.servingSize ?? '',
                  style: const TextStyle(color: Colors.grey, fontSize: 13)),
            ],
          ),
          const SizedBox(height: 16),
          if (items.isEmpty)
            const Text('暂无食材信息', style: TextStyle(color: Colors.grey))
          else
            ...List.generate((items.length / 2).ceil(), (rowIndex) {
              final left = items[rowIndex * 2];
              final right = rowIndex * 2 + 1 < items.length
                  ? items[rowIndex * 2 + 1]
                  : null;
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Expanded(
                        child: _buildIngredientCell(left.name, left.amount)),
                    const SizedBox(width: 24),
                    Expanded(
                      child: right != null
                          ? _buildIngredientCell(right.name, right.amount)
                          : const SizedBox(),
                    ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }

  Widget _buildIngredientCell(String name, String amount) {
    return Row(
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: Colors.orange.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.eco, size: 16, color: Colors.orange),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(name, maxLines: 1, overflow: TextOverflow.ellipsis),
        ),
        Text(amount, style: const TextStyle(color: Colors.grey, fontSize: 13)),
      ],
    );
  }

  Widget _buildStepsSection(RecipeDetail detail) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('图文步骤',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          if (detail.steps.isEmpty)
            const Text('暂无步骤信息', style: TextStyle(color: Colors.grey))
          else
            ...detail.steps.map(_buildStepItem),
        ],
      ),
    );
  }

  Widget _buildStepItem(RecipeStep step) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 10,
            backgroundColor: Colors.orange,
            child: Text('${step.stepNo}',
                style: const TextStyle(color: Colors.white, fontSize: 12)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (step.image != null && step.image!.isNotEmpty)
                  RecipeImage(
                    url: step.image,
                    borderRadius: BorderRadius.circular(8),
                  ),
                if (step.image != null && step.image!.isNotEmpty)
                  const SizedBox(height: 8),
                Text(step.content, style: const TextStyle(height: 1.5)),
                if (step.tip != null && step.tip!.isNotEmpty)
                  Text(step.tip!,
                      style: const TextStyle(
                          color: Colors.grey, fontSize: 12, height: 1.8)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
