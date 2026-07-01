import 'package:flutter/material.dart';
import 'package:fondia/api/interaction.dart';
import 'package:fondia/models/interaction_models.dart';
import 'package:fondia/pages/Mine/MineRecipeListTile.dart';

class CollectionView extends StatefulWidget {
  const CollectionView({super.key});

  @override
  State<CollectionView> createState() => _CollectionViewState();
}

class _CollectionViewState extends State<CollectionView> {
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
      final page = await InteractionApi.loadMineRecipes(InteractionApi.getMyCollects);
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

  Future<void> _uncollect(MineRecipeItem item) async {
    try {
      await InteractionApi.toggleCollect(item.recipeId);
      if (!mounted) return;
      await _loadData();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            const Text(
              '我的收藏',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.orange.withValues(alpha: 0.5)),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '共$_total个',
                style: const TextStyle(color: Colors.orange, fontSize: 12),
              ),
            ),
          ],
        ),
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
      return const Center(
        child: Text('还没有收藏菜谱', style: TextStyle(color: Colors.grey)),
      );
    }
    return RefreshIndicator(
      color: Colors.orange,
      onRefresh: _loadData,
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 24),
        itemCount: _items.length,
        itemBuilder: (context, index) {
          final item = _items[index];
          return MineRecipeListTile(
            item: item,
            trailingIcon: Icons.favorite,
            trailingColor: Colors.red,
            onTrailingTap: () => _uncollect(item),
          );
        },
      ),
    );
  }
}
