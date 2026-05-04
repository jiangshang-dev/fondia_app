import 'package:flutter/material.dart';

void main() {
  runApp(MainPage());
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // 当前激活索引
  int _currentIndex = 0;
  PageController _controller = PageController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('SingleChildScrollView滚动组件')),

        body: CustomScrollView(
          // 切片列表
          // 包裹普通widget的
          slivers: [
            SliverToBoxAdapter(
              child: Stack(
                children: [
                  // 轮播图
                  Container(
                    height: 260,
                    color: Colors.blue,
                    alignment: Alignment.center,
                    // 轮播图
                    child: PageView.builder(
                      // 控制器绑定给页面控制器
                      controller: _controller,
                      itemCount: 10, // 轮播图数量
                      // 构建轮播图子项
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          color: Colors.blue,
                          alignment: Alignment.center,
                          child: Text('轮播图${index + 1}'),
                        );
                      },
                    ),
                  ),

                  // 轮播图底部的小圆点
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    height: 40,
                    child: Container(
                      // color: Colors.red,
                      child: Row(
                        // 圆点居中
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(10, (index) {
                          return GestureDetector(
                            onTap: () {
                              print('点击了${index}');
                              // todo 跳转到指定位置，切换到具体的page
                              // _controller.jumpToPage(index);
                              _controller.animateToPage(index,
                                  duration: Duration(seconds: 1),
                                  curve: Curves.linear);
                              _currentIndex = index;
                              print('选择了${_currentIndex}');
                              setState(() {});
                            },
                            child: Container(
                              width: 10,
                              height: 10,
                              margin: EdgeInsets.only(left: 10),
                              decoration: BoxDecoration(
                                // 激活小圆点 红色还是白色，当前点击和轮播图索引一致
                                color: _currentIndex == index
                                    ? Colors.red
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 设置间距
            SliverToBoxAdapter(child: SizedBox(height: 10)),

            // 横向列表
            SliverPersistentHeader(
              delegate: _StickyCategory(),
              pinned: true, // 固定吸顶
            ),

            // 设置间距
            SliverToBoxAdapter(child: SizedBox(height: 10)),

            SliverList.separated(
              itemCount: 100,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  height: 100,
                  color: Colors.blue,
                  alignment: Alignment.center,
                  child: Text(
                    '列表项${index + 1}',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                );
              },

              separatorBuilder: (BuildContext context, int index) {
                return SizedBox(height: 20);
              },
            ),
          ],
        ),
      ),
    );
  }
}

// 水平横向的列表
class _StickyCategory extends SliverPersistentHeaderDelegate {
  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: Colors.white,
      child: ListView.builder(
        itemCount: 30,
        // 横向列表 水平间距
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            // 水平间距
            margin: EdgeInsets.symmetric(horizontal: 10),
            color: Colors.blue,
            width: 100,
            alignment: Alignment.center,
            child: Text(
              '分类${index + 1}',
              style: TextStyle(color: Colors.white),
            ),
          );
        },
      ),
    );
  }

  @override
  double get maxExtent => 80; // 最大展开高度

  @override
  double get minExtent => 60; // 最小折叠高度

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false; // 不需要重建
  }
}
