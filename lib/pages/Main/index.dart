import 'package:flutter/material.dart';
import 'package:fondia/pages/Category/index.dart';
import 'package:fondia/pages/Collection/index.dart';
import 'package:fondia/pages/Home/index.dart';
import 'package:fondia/pages/Mine/index.dart';
import 'package:fondia/pages/Top/index.dart';

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
        title: TopView(),
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
