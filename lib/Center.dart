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
        body: Center(
          child: Container(
            // 居中
            alignment: Alignment.center,
            width: 100,
            height: 100,
            decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(10)),
            child: Text('我是一个容器', style: TextStyle(color: Colors.white)),
          ),

        ),
      ),
    );
  }
}
