import 'package:flutter/material.dart';
import 'package:fondia/pages/CategoryDetail/index.dart';
import 'package:fondia/pages/Detail/index.dart';

// 首页
class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final List<Map<String, String>> _hotCuisineList = [
    {'name': '东北菜', 'image': 'lib/assets/addr/dongbei.png'},
    {'name': '台湾菜', 'image': 'lib/assets/addr/taipei.png'},
    {'name': '赤峰菜', 'image': 'lib/assets/addr/chifeng.png'},
    {'name': '北京菜', 'image': 'lib/assets/addr/tiantan.png'},
    {'name': '川菜', 'image': 'lib/assets/addr/chuan.png'},
  ];

  final List<Map<String, String>> _cuisineList = [
    {'name': '东北菜', 'icon': '❄️'},
    {'name': '台湾菜', 'icon': '🗼'},
    {'name': '赤峰菜', 'icon': '🏕️'},
    {'name': '北京菜', 'icon': '🏯'},
    {'name': '川菜', 'icon': '🌶️'},
    {'name': '粤菜', 'icon': '🥟'},
    {'name': '鲁菜', 'icon': '🏛️'},
    {'name': '苏菜', 'icon': '🪷'},
    {'name': '浙菜', 'icon': '🎋'},
    {'name': '湘菜', 'icon': '🌶️'},
    {'name': '闽菜', 'icon': '🏠'},
    {'name': '徽菜', 'icon': '🏰'},
  ];

  final List<Map<String, String>> _recommendList = [
    {'name': '地三鲜', 'desc': '东北经典下饭菜', 'likes': '2.1万', 'image': ''},
    {'name': '台湾牛肉面', 'desc': '汤鲜味美 · 一碗满足', 'likes': '1.8万', 'image': ''},
    {'name': '北京烤鸭', 'desc': '外酥里嫩 · 皮脆肉香', 'likes': '2.6万', 'image': ''},
    {'name': '赤峰手把肉', 'desc': '原汁原味 · 鲜香不腻', 'likes': '1.3万', 'image': ''},
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // 轮播图
          Padding(
            padding: EdgeInsets.all(10),
            // padding: EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              height: 220,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                  image: NetworkImage(
                    'https://i2.chuimg.com/bd39fd8c63374e5bb1d499e7c7dcd2e1_1036w_777h.jpg',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(0.4),
                          Colors.transparent,
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '家常菜：红烧肉',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 12),
                        Text(
                          '肥而不腻 · 软糯入味 · 超下饭',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '查看菜谱',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 4),
                              Icon(
                                Icons.chevron_right,
                                color: Colors.white,
                                size: 22,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 24),
          // 热门菜系
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Image.asset('lib/assets/hot.png', width: 32, height: 32),
                    SizedBox(width: 8),
                    Text(
                      '热门菜系',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                // Row(
                //   children: [
                //     Text(
                //       '全部菜系',
                //       style: TextStyle(color: Colors.grey[500], fontSize: 16),
                //     ),
                //     Icon(Icons.chevron_right, color: Colors.grey[500]),
                //   ],
                // ),
              ],
            ),
          ),
          SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child:
            // ListView.builder(
            //   scrollDirection: Axis.horizontal,
            //   itemCount: 5,
            // )
            LayoutBuilder(
              builder: (context, constraints) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // 分类详情跳转
                  children: _hotCuisineList.map((item) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CategoryDetailView(
                              // 这里传递参数，例如菜品名称
                              // dishName: item['name'],
                            ),
                          ),
                        );
                      },
                      child: Column(
                        children: [
                          Container(
                            width: 70,
                            height: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              image: DecorationImage(
                                image: AssetImage(item['image']!),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            item['name']!,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
          SizedBox(height: 24),
          // 菜系分类
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Container(
                  width: 6,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                SizedBox(width: 12),
                Text(
                  '菜系分类',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisExtent: 95, // ✅ 关键：固定每个格子高度
              ),
              itemCount: _cuisineList.length,
              itemBuilder: (context, index) {
                final item = _cuisineList[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CategoryDetailView(
                          // cuisine: item,
                        ),
                      ),
                    );
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: Text(
                            item['icon']!,
                            style: TextStyle(fontSize: 26),
                          ),
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        item['name']!,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 8),
          // 向下箭头查看更多
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Icon(
              Icons.keyboard_arrow_down,
              color: Colors.grey[500],
              size: 32,
            ),
          ),
          SizedBox(height: 24),
          // 今日推荐
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 6,
                      height: 24,
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    SizedBox(width: 12),
                    Text(
                      '今日推荐',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      '换一换',
                      style: TextStyle(color: Colors.grey[500], fontSize: 16),
                    ),
                    SizedBox(width: 4),
                    Icon(Icons.refresh, color: Colors.grey[500], size: 20),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.85,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: _recommendList.length,
              itemBuilder: (context, index) {
                final item = _recommendList[index];
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 140,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(16),
                          ),
                          image: DecorationImage(
                            image: NetworkImage(item['image']!),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['name']!,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              item['desc']!,
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 8),
                            Row(children: [SizedBox(width: 4)]),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 24),
        ],
      ),
    );
  }
}
