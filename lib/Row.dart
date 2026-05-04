/*
  线性布局
 */
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
          // 宽度为double.infinity 正无穷大 相当于css的 100%
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(color: Colors.yellow),
          child: Row(
            // 对齐方式
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,// 两头对齐
            // mainAxisAlignment: MainAxisAlignment.spaceAround, // 环绕模式
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly, // 平均分
            // mainAxisAlignment: MainAxisAlignment.start, // 从头排列
            // mainAxisAlignment: MainAxisAlignment.end, // 尾部排列
            mainAxisAlignment: MainAxisAlignment.center, // 居中排列
            // crossAxisAlignment: CrossAxisAlignment.center, // 交叉轴排列 垂直对齐
            // crossAxisAlignment: CrossAxisAlignment.start, // 交叉轴排列 垂直对齐
            children: [
              Container(
                width: 100,
                height: 100,
                color: Colors.blue,
              ),
              // SizedBox(width: 10),
              Container(
                margin: EdgeInsetsGeometry.only(left: 10),
                height: 100,
                width: 100,
                color: Colors.blue,
              ),
              // SizedBox(width: 10),
              Container(
                margin: EdgeInsetsGeometry.only(left: 10),
                height: 100,
                width: 100,
                color: Colors.blue,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
