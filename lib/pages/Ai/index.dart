import 'package:flutter/material.dart';
import 'package:fondia/pages/Ai/AiExclusive.dart';
import 'package:fondia/pages/AiChat/index.dart';

class AiView extends StatefulWidget {
  const AiView({super.key});

  @override
  State<AiView> createState() => _AiViewState();
}

class _AiViewState extends State<AiView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildBanner(),
            _buildSectionTitle("热门需求", showMore: true, icon: Icons.local_fire_department, iconColor: Colors.orange),
            _buildHotDemands(),
            _buildSectionTitle("适用人群", showMore: true, icon: Icons.person_outline, iconColor: Colors.orange),
            _buildTargetAudiences(),
            _buildAIConsultCard(),
            _buildSectionTitle("今日推荐", showMore: true, moreText: "换一换", moreIcon: Icons.refresh, icon: Icons.edit_note, iconColor: Colors.orange),
            _buildDailyRecommendations(),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // 1. AI 健康菜谱助手 Banner
  Widget _buildBanner() {
    return Container(
      margin: const EdgeInsets.all(16),
      height: 180,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: const DecorationImage(
          image: NetworkImage('https://images.unsplash.com/photo-1546069901-ba9599a7e63c'), // 请替换为实际的沙拉背景图
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [Colors.white.withOpacity(0.9), Colors.transparent],
            begin: Alignment.centerLeft,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                const Text("AI健康菜谱助手", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF4D2C19))),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(color: Colors.orange, borderRadius: BorderRadius.circular(10)),
                  child: const Text("智能定制", style: TextStyle(color: Colors.white, fontSize: 10)),
                )
              ],
            ),
            const SizedBox(height: 8),
            const Text("根据身体状况和饮食目标\n为你定制专属健康饮食方案", style: TextStyle(color: Colors.grey, fontSize: 13, height: 1.5)),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Colors.orangeAccent, Colors.orange]),
                borderRadius: BorderRadius.circular(20),
              ),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AiChatView(
                        // 这里传递参数，例如菜品名称
                        // dishName: item['name'],
                      ),
                    ),
                  );
                },
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("开始咨询", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    Icon(Icons.arrow_forward, color: Colors.white, size: 16),
                  ],
                ),
              )
            )
          ],
        ),
      ),
    );
  }

  // 2. 通用标题组件
  Widget _buildSectionTitle(String title, {bool showMore = false, String moreText = "全部功能", IconData? moreIcon, IconData? icon, Color? iconColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          if (icon != null) Icon(icon, color: iconColor, size: 20),
          const SizedBox(width: 4),
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const Spacer(),
          if (showMore)
            Row(
              children: [
                Text(moreText, style: const TextStyle(color: Colors.grey, fontSize: 13)),
                Icon(moreIcon ?? Icons.chevron_right, color: Colors.grey, size: 16),
              ],
            ),
        ],
      ),
    );
  }

  // 3. 热门需求列表
  Widget _buildHotDemands() {
    final items = [
      {"name": "减脂餐", "sub": "科学搭配\n轻松掉秤", "icon": Icons.scale, "color": Colors.green},
      {"name": "控糖饮食", "sub": "稳定血糖\n健康饮食", "icon": Icons.water_drop, "color": Colors.blue},
      {"name": "高血压饮食", "sub": "低盐低脂\n保护心血管", "icon": Icons.favorite, "color": Colors.red},
      {"name": "高尿酸饮食", "sub": "低嘌呤饮食\n远离痛风", "icon": Icons.lens_blur, "color": Colors.purple},
    ];

    return SizedBox(
      height: 130,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        scrollDirection: Axis.horizontal,
        itemCount: items.length + 1,
        itemBuilder: (context, index) {
          if (index == items.length) {
            return _buildDemandItem("更多需求", "慢病管理\n营养指导", Icons.grid_view_rounded, Colors.brown);
          }
          final item = items[index];
          return _buildDemandItem(item['name'] as String, item['sub'] as String, item['icon'] as IconData, item['color'] as Color);
        },
      ),
    );
  }

  Widget _buildDemandItem(String name, String sub, IconData icon, Color color) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => AiChatView(initialConsultType: name)),
        );
      },
      child: Container(
      width: 85,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [color.withOpacity(0.05), Colors.white],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 30),
          const SizedBox(height: 8),
          Text(name, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(sub, style: const TextStyle(fontSize: 9, color: Colors.grey), textAlign: TextAlign.center),
        ],
      ),
    ),
    );
  }

  // 4. 适用人群
  Widget _buildTargetAudiences() {
    final groups = [
      {"title": "孕妇营养", "sub": "孕期分阶段\n营养饮食方案", "img": "https://via.placeholder.com/150"},
      {"title": "儿童辅食", "sub": "分龄辅食添加\n营养均衡成长", "img": "https://via.placeholder.com/150"},
      {"title": "老人养生", "sub": "营养易消化\n增强免疫力", "img": "https://via.placeholder.com/150"},
      {"title": "全家健康", "sub": "多成员管理\n定制全家饮食", "img": "https://via.placeholder.com/150"},
    ];

    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.85,
      ),
      itemCount: groups.length,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  child: Image.network(groups[index]['img']!, fit: BoxFit.cover, width: double.infinity),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(groups[index]['title']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    const SizedBox(height: 2),
                    Text(groups[index]['sub']!, style: const TextStyle(color: Colors.grey, fontSize: 10)),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  // 5. AI 咨询卡片
  Widget _buildAIConsultCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF9F2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.orange.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const CircleAvatar(backgroundColor: Colors.white, child: Icon(Icons.air, color: Colors.orange)),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Hi，我是你的AI营养师", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    Text("有什么饮食问题都可以问我哦~", style: TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AiExclusiveView()),
                  );
                },
                child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(color: Colors.orange, borderRadius: BorderRadius.circular(20)),
                child: const Text("去咨询 >", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
              ),
              )
            ],
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildQueryChip("减脂期间可以吃米饭吗？"),
                _buildQueryChip("糖尿病人一天食谱怎么搭配？"),
                _buildQueryChip("孕期吃什么对宝宝好？"),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildQueryChip(String text) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AiExclusiveView(initialMessage: text, newSession: true),
          ),
        );
      },
      child: Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.grey.withOpacity(0.1))),
      child: Text(text, style: const TextStyle(fontSize: 11, color: Colors.black87)),
    ),
    );
  }

  // 6. 今日推荐菜谱
  Widget _buildDailyRecommendations() {
    final recipes = [
      {"name": "低卡鸡胸蔬菜沙拉", "tags": ["减脂餐", "低卡高蛋白"], "img": ""},
      {"name": "清炒虾仁西兰花", "tags": ["控糖餐", "低脂低糖"], "img": ""},
      {"name": "山药枸杞炖鸡汤", "tags": ["孕妇餐", "营养滋补"], "img": ""},
    ];

    return SizedBox(
      height: 180,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        scrollDirection: Axis.horizontal,
        itemCount: recipes.length,
        itemBuilder: (context, index) {
          final recipe = recipes[index];
          return Container(
            width: 140,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  child: Image.network(recipe['img'] as String, height: 100, width: 140, fit: BoxFit.cover),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(recipe['name'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12), maxLines: 1),
                      const SizedBox(height: 4),
                      Wrap(
                        spacing: 4,
                        children: (recipe['tags'] as List).map((tag) => Container(
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                          decoration: BoxDecoration(color: Colors.blue.withOpacity(0.05), borderRadius: BorderRadius.circular(4)),
                          child: Text(tag, style: const TextStyle(color: Colors.blue, fontSize: 8)),
                        )).toList(),
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}