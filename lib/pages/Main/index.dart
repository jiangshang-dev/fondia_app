import 'package:flutter/material.dart';
import 'package:fondia/pages/Category/index.dart';
import 'package:fondia/pages/Collection/index.dart';
import 'package:fondia/pages/Home/index.dart';
import 'package:fondia/pages/Mine/index.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  final List<Map<String, String>> _tabList = [
    {
      'text': '首页',
      'icon': 'lib/assets/ic_public_home_normal.png',
      'active_icon': 'lib/assets/ic_public_home_active.png',
    },
    {
      'text': '分类',
      'icon': 'lib/assets/ic_public_pro_normal.png',
      'active_icon': 'lib/assets/ic_public_pro_active.png',
    },
    {
      'text': '收藏',
      'icon': 'lib/assets/ic_public_cart_normal.png',
      'active_icon': 'lib/assets/ic_public_cart_active.png',
    },
    {
      'text': '我的',
      'icon': 'lib/assets/ic_public_my_normal.png',
      'active_icon': 'lib/assets/ic_public_my_active.png',
    },
  ];

  List<BottomNavigationBarItem> _getTabBarWidget() {
    return List.generate(_tabList.length, (index) {
      return BottomNavigationBarItem(
        icon: Image.asset(_tabList[index]['icon']!, width: 30, height: 30),
        activeIcon: Image.asset(
          _tabList[index]['active_icon']!,
          width: 30,
          height: 30,
        ),
        label: _tabList[index]['text']!,
      );
    });
  }

  List<Widget> _getChildren() {
    return [HomeView(), CategoryView(),  CollectionView(), MineView()];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '菜谱',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Column(
                  children: [
                    Text(
                      '让做饭更简单',
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                    SizedBox(width: 8),
                    Container(
                      height: 4,
                      width: 60,
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(width: 16),
            Expanded(
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  // color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  // 搜索框
                  decoration: InputDecoration(
                    hintText: '搜索菜谱、食材、菜系',
                    hintStyle: TextStyle(color: Colors.grey[500], fontSize: 16),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.grey[600],
                      size: 24,
                    ),
                    // border: ,
                    border: InputBorder.none,
                    // border: OutlineInputBorder(
                    //     borderRadius: BorderRadius.circular(5),
                    // ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Icon(
              Icons.notifications_none,
              color: Colors.black,
              size: 28,
            ),
          ),
        ],
      ),
      body: SafeArea(child: IndexedStack(
        children: _getChildren(),
        index: _currentIndex,
      )),
      bottomNavigationBar: BottomNavigationBar(
        showUnselectedLabels: true,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        currentIndex: _currentIndex,
        items: _getTabBarWidget(),
      ),
    );
  }
}
