import 'package:flutter/material.dart';
import 'package:fondia/components/Home/Top.dart';
import 'package:fondia/l10n/app_localizations.dart';
import 'package:fondia/pages/Ai/index.dart';
import 'package:fondia/pages/Category/index.dart';
import 'package:fondia/pages/Home/index.dart';
import 'package:fondia/pages/Mine/index.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  static const _tabIcons = [
    ('lib/assets/ic_public_home_normal.png', 'lib/assets/ic_public_home_active.png'),
    ('lib/assets/ic_public_pro_normal.png', 'lib/assets/ic_public_pro_active.png'),
    ('lib/assets/ic_public_cart_normal.png', 'lib/assets/ic_public_cart_active.png'),
    ('lib/assets/ic_public_my_normal.png', 'lib/assets/ic_public_my_active.png'),
  ];

  List<BottomNavigationBarItem> _getTabBarWidget(AppLocalizations l10n) {
    final labels = [l10n.tabHome, l10n.tabCategory, l10n.tabAi, l10n.tabMine];
    return List.generate(_tabIcons.length, (index) {
      return BottomNavigationBarItem(
        icon: Image.asset(_tabIcons[index].$1, width: 30, height: 30),
        activeIcon: Image.asset(_tabIcons[index].$2, width: 30, height: 30),
        label: labels[index],
      );
    });
  }

  List<Widget> _getChildren() {
    return const [HomeView(), CategoryView(), AiView(), MineView()];
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: _currentIndex != 3
          ? AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              title: TopView(),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Icon(Icons.notifications_none, color: Colors.black, size: 28),
                ),
              ],
            )
          : null,
      body: SafeArea(
        child: IndexedStack(index: _currentIndex, children: _getChildren()),
      ),
      bottomNavigationBar: BottomNavigationBar(
        showUnselectedLabels: true,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
        onTap: (index) => setState(() => _currentIndex = index),
        currentIndex: _currentIndex,
        items: _getTabBarWidget(l10n),
      ),
    );
  }
}
