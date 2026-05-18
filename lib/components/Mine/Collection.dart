import 'package:flutter/material.dart';

class CollectionView extends StatefulWidget {
  const CollectionView({super.key});

  @override
  State<CollectionView> createState() => _CollectionViewState();
}

class _CollectionViewState extends State<CollectionView> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
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
            const Text('我的收藏', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 22)),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.orange.withOpacity(0.5)),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text('共56个', style: TextStyle(color: Colors.orange, fontSize: 12)),
            ),
          ],
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search, color: Colors.black)),
          TextButton(onPressed: () {}, child: const Text('管理', style: TextStyle(color: Colors.black))),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildTodaySummary(),
            _buildFilterBar(),
            _buildCollectionList(),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Text("没有更多了", style: TextStyle(color: Colors.grey, fontSize: 12)),
            ),
            _buildRecommendationSection(),
          ],
        ),
      ),
    );
  }

  // 1. 今日收藏统计
  Widget _buildTodaySummary() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: Color(0xFFFFF0ED),
            child: Icon(Icons.favorite, color: Colors.red),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(TextSpan(children: [
                  TextSpan(text: "今日已收藏 "),
                  TextSpan(text: "2", style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
                  TextSpan(text: " 道菜谱"),
                ])),
                Text("快去试试吧，记录美味生活~", style: TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              shape: StadiumBorder(),
              elevation: 0,
            ),
            child: const Text("去看看"),
          )
        ],
      ),
    );
  }

  // 2. 筛选栏
  Widget _buildFilterBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          const Text("默认排序", style: TextStyle(fontSize: 14)),
          const Icon(Icons.keyboard_arrow_down, size: 18),
          const SizedBox(width: 20),
          const Text("全部菜谱", style: TextStyle(fontSize: 14, color: Colors.grey)),
          const Icon(Icons.keyboard_arrow_down, size: 18, color: Colors.grey),
          const Spacer(),
          const Icon(Icons.grid_view_rounded, size: 20, color: Colors.black54),
        ],
      ),
    );
  }

  // 3. 收藏列表项
  Widget _buildCollectionList() {
    final List<Map<String, String>> items = [
      {"title": "家常菜：红烧肉", "desc": "肥而不腻，软糯入味，超下饭", "tag": "家常菜", "views": "2.1万"},
      {"title": "清蒸鲈鱼", "desc": "鲜嫩无腥味，原汁原味，营养丰富", "tag": "粤菜", "views": "1.8万"},
      {"title": "四川麻辣火锅", "desc": "麻辣过瘾，热辣鲜香，聚会必备", "tag": "川菜", "views": "3.6万"},
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset('lib/assets/addr/chuan.png'),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(items[index]['title']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        const Icon(Icons.favorite, color: Colors.red, size: 20),
                      ],
                    ),
                    Text(items[index]['desc']!, style: const TextStyle(color: Colors.grey, fontSize: 12), maxLines: 1),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const CircleAvatar(radius: 8, backgroundColor: Colors.grey),
                        const SizedBox(width: 4),
                        const Text("小厨爱做饭", style: TextStyle(fontSize: 10, color: Colors.grey)),
                        const SizedBox(width: 8),
                        const Icon(Icons.play_circle_outline, size: 12, color: Colors.grey),
                        Text(" ${items[index]['views']}", style: const TextStyle(fontSize: 10, color: Colors.grey)),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(color: Colors.orange[50], borderRadius: BorderRadius.circular(4)),
                          child: Text(items[index]['tag']!, style: const TextStyle(color: Colors.orange, fontSize: 10)),
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  // 4. 猜你喜欢区域
  Widget _buildRecommendationSection() {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("猜你喜欢", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Row(children: [Text("换一换 ", style: TextStyle(color: Colors.grey, fontSize: 12)), Icon(Icons.refresh, size: 14, color: Colors.grey)]),
            ],
          ),
        ),
        GridView.builder(
          padding: const EdgeInsets.all(16),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.8,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: 4,
          itemBuilder: (context, index) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network('https://via.placeholder.com/150', fit: BoxFit.cover, width: double.infinity),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Text("精致菜名示例", style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                const Row(
                  children: [
                    Icon(Icons.favorite_border, size: 14, color: Colors.red),
                    Text(" 1.2万", style: TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                )
              ],
            );
          },
        )
      ],
    );
  }
}