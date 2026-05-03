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
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('头部区域')),
        // Center 充满了父组件
        body: Container(
          // color: Colors.amber,
          // width: 100,
          // height: 100,
          // padding: EdgeInsets.all(20),
          decoration: BoxDecoration(color: Colors.amber),
          // color: Colors.amber,
          // width: 100,
          // height: 100,
          // padding: EdgeInsets.all(20),
          child: Padding(
            // 设置四边的间距
            padding: EdgeInsetsGeometry.all(20),
            child: Container(color: Colors.blue),
          ),
        ),
      ),
    );
  }
}
