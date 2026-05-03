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
          color: Colors.blue,
          // width: 100,
          // height: 100,
          child: Align(
            alignment: Alignment.center,
            // 宽度因子
            widthFactor: 3,
            // 高度因子
            heightFactor: 4,
            child: Icon(
              Icons.star, // 显示的图标
              size: 150, // 50px
              color: Colors.yellow,
            ),

          ),
        )
      ),
    );
  }
}
