import 'package:flutter/material.dart';

void main() {
  runApp(MainPage());
}

// 无状态组件
class MainPage extends StatelessWidget {
  const MainPage({super.key});

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
              child: Container(
                height: 260,
                color: Colors.blue,
                alignment: Alignment.center,
                // 轮播图
                child: PageView.builder(
                    itemCount: 10,
                    itemBuilder: (BuildContext context, int index){
                      return Container(
                        color: Colors.red,
                        alignment: Alignment.center,
                        child: Text('轮播图${index + 1}'),
                      );
                    }
                ),
              ),
            ),

            // 设置间距
            SliverToBoxAdapter(child: SizedBox(height: 10)),

            // 横向列表
            SliverPersistentHeader(
                delegate: _StickyCategory(),
                pinned: true // 固定吸顶
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
                    child: Text('列表项${index + 1}', style: TextStyle(fontSize: 20, color: Colors.white)),
                  );
                },

                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(height: 20);
                })
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
