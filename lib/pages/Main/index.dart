
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  // 底部导航tab tab列表
  final List<Map<String, String>> _tabList = [
    {
      'text': '首页',
      'icon': 'lib/assets/ic_public_home_normal.png', // 默认图标
      'active_icon': 'lib/assets/ic_public_home_active.png', // 选中图标
    },
    {
      'text': '分类',
      'icon': 'lib/assets/ic_public_pro_normal.png', // 默认图标
      'active_icon': 'lib/assets/ic_public_pro_active.png', // 选中图标
    },
    {
      'text': '收藏',
      'icon': 'lib/assets/ic_public_cart_normal.png', // 默认图标
      'active_icon': 'lib/assets/ic_public_cart_active.png', // 选中图标
    },
    {
      'text': '我的',
      'icon': 'lib/assets/ic_public_my_normal.png', // 默认图标
      'active_icon': 'lib/assets/ic_public_my_active.png', // 选中图标
    },
  ];

  // 返回底部导航tab
  List<BottomNavigationBarItem> _getTabBarWidget() {
    return List.generate(_tabList.length, (index){
      return BottomNavigationBarItem(
          icon: Image.asset(_tabList[index]['icon']!, width: 30, height: 30),
          activeIcon: Image.asset(_tabList[index]['active_icon']!, width: 30, height: 30,),
          label: _tabList[index]['text']!
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('首页'),
      ),
      body: Center(
        child: Text('首页'),
      ),
      bottomNavigationBar: BottomNavigationBar(
        showUnselectedLabels:  true,
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
