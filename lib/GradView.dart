import 'package:flutter/material.dart';

void main() {
  runApp(MainPage());
}

// 无状态组件
class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    print("无状态组件的构建");

    ScrollController _controller = ScrollController();

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('SingleChildScrollView滚动组件')),
        // Center 充满了父组件

        // SingleChildScrollView 滚动组件
        body: GridView.count(
          // scrollDirection: Axis.vertical, // 垂直滚动 默认
          scrollDirection: Axis.horizontal, // 水平滚动
          crossAxisCount: 4, // 设置固定的列数或行数
          // 主轴
          mainAxisSpacing: 10,
          // 交叉轴
          crossAxisSpacing: 10,
          padding: EdgeInsets.all(10),
          children: List.generate(100, (index) {
            return Container(
              alignment: Alignment.center,
              color: Colors .blue,
              child: Text('${index+1}', style: TextStyle(fontSize: 20, color: Colors.white),),
            );
          }),
        ),
      ),
    );
  }
}
