import 'package:flutter/material.dart';
import 'package:fondia/api/interaction.dart';
import 'package:fondia/models/interaction_models.dart';
import 'package:fondia/pages/CategoryDetail/DishDetail.dart';
import 'package:fondia/pages/Mine/MineRecipeListTile.dart';
import 'package:fondia/utils/recipe_image.dart';

/// 浏览记录页面
class BrowsingHistoryView extends StatefulWidget {
  const BrowsingHistoryView({super.key});

  @override
  State<BrowsingHistoryView> createState() => _BrowsingHistoryViewState();
}

class _BrowsingHistoryViewState extends State<BrowsingHistoryView> {
  List<MineRecipeItem> _items = [];
  int _total = 0;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final page =
          await InteractionApi.loadMineRecipes(InteractionApi.getMyBrowseHistory);
      if (!mounted) return;
      setState(() {
        _items = page.items;
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

  List<_HistoryGroup> _groupItems() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    final groups = <String, List<MineRecipeItem>>{};
    for (final item in _items) {
      final label = _resolveGroupLabel(item.actionTime, today, yesterday);
      groups.putIfAbsent(label, () => []).add(item);
    }

    const order = ['今天', '昨天', '更早之前'];
    return order
        .where((key) => groups.containsKey(key))
        .map((key) => _HistoryGroup(label: key, items: groups[key]!))
        .toList();
  }

  String _resolveGroupLabel(String? time, DateTime today, DateTime yesterday) {
    if (time == null || time.isEmpty) return '更早之前';
    final parsed = DateTime.tryParse(time.replaceFirst(' ', 'T'));
    if (parsed == null) return '更早之前';
    final date = DateTime(parsed.year, parsed.month, parsed.day);
    if (date == today) return '今天';
    if (date == yesterday) return '昨天';
    return '更早之前';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff9f6f3),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: Colors.black87, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          '浏览记录${_total > 0 ? ' ($_total)' : ''}',
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.orange),
      );
    }
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_error!, style: const TextStyle(color: Colors.grey)),
            TextButton(onPressed: _loadData, child: const Text('重试')),
          ],
        ),
      );
    }
    if (_items.isEmpty) {
      return _buildEmptyState();
    }

    final groups = _groupItems();
    return RefreshIndicator(
      color: Colors.orange,
      onRefresh: _loadData,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: groups.length,
        itemBuilder: (context, groupIndex) {
          final group = groups[groupIndex];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 4, top: 12, bottom: 10),
                child: Text(
                  group.label,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: group.items.length,
                  separatorBuilder: (_, __) => const Padding(
                    padding: EdgeInsets.only(left: 88),
                    child: Divider(
                      height: 1,
                      thickness: 0.5,
                      color: Color(0xFFEEEEEE),
                    ),
                  ),
                  itemBuilder: (context, itemIndex) {
                    return _buildHistoryItem(group.items[itemIndex]);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHistoryItem(MineRecipeItem item) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DishDetail(recipeId: item.recipeId),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                width: 64,
                height: 64,
                child: RecipeImage(url: item.coverImage, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.local_fire_department_rounded,
                          size: 14, color: Color(0xfff3a033)),
                      const SizedBox(width: 2),
                      Text(
                        '${formatInteractionCount(item.viewCount)}次看过',
                        style: const TextStyle(
                            color: Colors.black38, fontSize: 12),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        formatActionTimeLabel(item.actionTime),
                        style: const TextStyle(
                            color: Colors.black26, fontSize: 11),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.history_toggle_off_rounded,
              size: 64, color: Colors.black12),
          const SizedBox(height: 16),
          const Text(
            '最近没有浏览记录哦~',
            style: TextStyle(color: Colors.black38, fontSize: 15),
          ),
          const SizedBox(height: 12),
          TextButton(onPressed: _loadData, child: const Text('刷新')),
        ],
      ),
    );
  }
}

class _HistoryGroup {
  final String label;
  final List<MineRecipeItem> items;

  const _HistoryGroup({required this.label, required this.items});
}
