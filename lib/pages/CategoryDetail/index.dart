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
      // 顶部导航栏：返回与分享
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.black54, size: 20,
            )
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.ios_share, color: Colors.black54),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // 1. 1:1 还原的菜系介绍头部
          SliverToBoxAdapter(
            child: _buildHeaderCard(),
          ),

          // 2. 主选项卡 (菜品 / 主食)
          SliverPersistentHeader(
            pinned: true,
            delegate: _SliverAppBarDelegate(
              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(bottom: BorderSide(color: Color(0xFFF5F5F5), width: 1)),
                ),
                child: TabBar(
                  controller: _mainTabController,
                  tabs: const [Tab(text: '菜品'), Tab(text: '主食')],
                  labelColor: const Color(0xFFFF742D), // 调整为图中的橙色
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: const Color(0xFFFF742D),
                  indicatorSize: TabBarIndicatorSize.label,
                  labelStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  unselectedLabelStyle: const TextStyle(fontSize: 18),
                ),
              ),
            ),
          ),

          // 3. 菜品目录标题
          SliverToBoxAdapter(
            child: _buildSectionTitle('菜品目录'),
          ),

          // 4. 横向分类标签 (全部, 家常菜...)
          SliverPersistentHeader(
            pinned: true,
            delegate: _SliverAppBarDelegate(
              Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: _buildCategoryFilter(),
              ),
            ),
          ),

          // 5. 菜品网格列表
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.72,
              ),
              delegate: SliverChildBuilderDelegate(
                    (context, index) => _buildDishItem(),
                childCount: 12,
              ),
            ),
          ),

          const SliverToBoxAdapter(child: Center(child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Text('没有更多了', style: TextStyle(color: Colors.grey, fontSize: 12)),
          ))),
        ],
      ),
    );
  }

  // 1:1 还原的头部卡片
  Widget _buildHeaderCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 左侧图片，带圆角和轻微阴影
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.01),
                  // color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: ClipRRect(
              // todo 动态图
              child: Image.asset('lib/assets/addr/chifeng.png'),
            ),
          ),
          const SizedBox(width: 16),
          // 右侧介绍
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '东北菜',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF333333)),
                ),
                const SizedBox(height: 8),
                const Text(
                  '东北菜以炖、焖、酱、熏为主要烹饪方式，口味咸鲜浓厚，食材丰富实在，讲究大锅大碗，豪爽实在，充满东北风情。',
                  style: TextStyle(fontSize: 13, color: Color(0xFF666666), height: 1.5),
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                // 标签行
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildTag('特色: 咸鲜浓郁'),
                      const SizedBox(width: 6),
                      _buildTag('烹饪: 炖/焖/酱/熏'),
                      const SizedBox(width: 6),
                      _buildTag('代表食材: 猪肉/酸菜/玉米'),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  // 1:1 还原标签样式
  Widget _buildTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5), // 对应图中灰底
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 10, color: Color(0xFF999999)),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 18,
            decoration: BoxDecoration(
              color: const Color(0xFFFF742D),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF333333)),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return SizedBox(
      height: 32,
      child: TabBar(
        controller: _categoryTabController,
        isScrollable: true,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: const Color(0xFFFF742D),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: const Color(0xFF666666),
        indicatorSize: TabBarIndicatorSize.tab,
        labelPadding: const EdgeInsets.symmetric(horizontal: 16),
        tabs: const [
          Tab(child: Text('全部', style: TextStyle(fontSize: 13))),
          Tab(child: Text('家常菜', style: TextStyle(fontSize: 13))),
          Tab(child: Text('炖菜', style: TextStyle(fontSize: 13))),
          Tab(child: Text('杀猪菜', style: TextStyle(fontSize: 13))),
          Tab(child: Text('熏酱', style: TextStyle(fontSize: 13))),
          Tab(child: Text('凉菜', style: TextStyle(fontSize: 13))),
          Tab(child: Text('汤羹', style: TextStyle(fontSize: 13))),
        ],
      ),
    );
  }

  Widget _buildDishItem() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.network('https://placeholder.com/200', fit: BoxFit.cover, width: double.infinity),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('红烧肉', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF333333))),
                const SizedBox(height: 4),
                const Text('肥而不腻，软糯入味', style: TextStyle(color: Color(0xFF999999), fontSize: 12)),
                const SizedBox(height: 8),
                Row(
                  children: const [
                    Icon(Icons.favorite_border, size: 14, color: Color(0xFFFF4D4D)),
                    SizedBox(width: 4),
                    Text('2.1万', style: TextStyle(fontSize: 12, color: Color(0xFF999999))),
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

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._widget);
  final Widget _widget;

  @override
  double get minExtent => 48;
  @override
  double get maxExtent => 48;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return _widget;
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) => false;
}