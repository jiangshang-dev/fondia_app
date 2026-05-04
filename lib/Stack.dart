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

    List<Widget> getList() {
      return List.generate(10, (index) {
        return Container(
          margin: EdgeInsets.all(5),
          color: Colors.red,
          width: 100,
          height: 100,
          child: Text("$index"),
        );
      });
    }

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('头部区域')),
        // Center 充满了父组件
        body: Container(
          color: Colors.grey,
          // 宽度 撑满：double.infinity
          width: double.infinity,
          height: double.infinity,
          child: Stack(
            // 对齐方式
            alignment: Alignment.centerLeft,
            // alignment: Alignment.topCenter,
            // alignment: Alignment.bottomCenter,
            // alignment: Alignment.center,
            children: [
              Container(width: 300, height: 300, color: Colors.blue),
              Container(width: 200, height: 200, color: Colors.red),
              Container(width: 150, height: 150, color: Colors.yellow),
              Container(width: 100, height: 100, color: Colors.green),
            ],
          ),
        ),
      ),
    );
  }
}
