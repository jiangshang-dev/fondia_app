

import 'package:flutter/material.dart';

class CategoryDetailView extends StatefulWidget {
  const CategoryDetailView({super.key});

  @override
  State<CategoryDetailView> createState() => _CategoryDetailViewState();
}

class _CategoryDetailViewState extends State<CategoryDetailView> with TickerProviderStateMixin {
  late TabController _mainTabController;
  late TabController _categoryTabController;

  @override
  void initState() {
    super.initState();
    _mainTabController = TabController(length: 2, vsync: this);
    _categoryTabController = TabController(length: 7, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // 1. 顶部菜系介绍卡片
          SliverToBoxAdapter(
            child: _buildHeaderCard(),
          ),

          // 2. 主选项卡 (菜品 / 主食)
          SliverPersistentHeader(
            pinned: true,
            delegate: _SliverAppBarDelegate(
              Container(
                color: Colors.white,
                child: TabBar(
                  controller: _mainTabController,
                  tabs: const [Tab(text: '菜品'), Tab(text: '主食')],
                  labelColor: Colors.orange,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: Colors.orange,
                  indicatorSize: TabBarIndicatorSize.label,
                  isScrollable: false,
                ),
              ),
            ),
          ),

          // 3. 菜品目录标题与分类标签
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle('菜品目录'),
                _buildCategoryFilter(),
              ],
            ),
          ),

          // 4. 菜品网格列表
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.75,
              ),
              delegate: SliverChildBuilderDelegate(
                    (context, index) => _buildDishItem(),
                childCount: 6, // 模拟数据数量
              ),
            ),
          ),

          // 底部留白
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  // 顶部卡片组件
  Widget _buildHeaderCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 左侧图片
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              'https://placeholder.com/120', // 请替换为实际图片
              width: 120,
              height: 120,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 16),
          // 右侧文字介绍
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('东北菜', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                const Text(
                  '东北菜以炖、焖、酱、熏为主要烹饪方式，口味咸鲜浓厚，食材丰富实在...',
                  style: TextStyle(fontSize: 13, color: Colors.grey),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  children: [
                    _buildTag('特色: 咸鲜浓郁'),
                    _buildTag('烹饪: 炖/焖/酱/熏'),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(text, style: const TextStyle(fontSize: 10, color: Colors.orange)),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(width: 4, height: 16, color: Colors.orange),
          const SizedBox(width: 8),
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return Container(
      height: 40,
      margin: const EdgeInsets.only(bottom: 12),
      child: TabBar(
        controller: _categoryTabController,
        isScrollable: true,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.orange,
        ),
        labelColor: Colors.white,
        unselectedLabelColor: Colors.black87,
        tabs: const [
          Tab(text: '  全部  '),
          Tab(text: '家常菜'),
          Tab(text: '炖菜'),
          Tab(text: '杀猪菜'),
          Tab(text: '熏酱'),
          Tab(text: '凉菜'),
          Tab(text: '汤羹'),
        ],
      ),
    );
  }

  Widget _buildDishItem() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 4, spreadRadius: 1)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.network('https://placeholder.com/150', fit: BoxFit.cover, width: double.infinity),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('红烧肉', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const Text('肥而不腻，软糯入味', style: TextStyle(color: Colors.grey, fontSize: 11)),
                const SizedBox(height: 4),
                Row(
                  children: const [
                    Icon(Icons.favorite_border, size: 14, color: Colors.redAccent),
                    SizedBox(width: 4),
                    Text('2.1万', style: TextStyle(fontSize: 11, color: Colors.grey)),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

// 辅助类：用于保持 TabBar 悬停
class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);
  final Container _tabBar;

  @override
  double get minExtent => 48;
  @override
  double get maxExtent => 48;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return _tabBar;
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) => false;
}