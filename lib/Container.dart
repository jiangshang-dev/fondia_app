import 'package:flutter/material.dart';

/*
  加减事件按钮小示例
 */
void main() {
  runApp(MainPage());
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          child: Container(
            // 居中
            alignment: Alignment.center,
            // 宽高
            height: 200,
            width: 200,
            // 边框
            decoration: BoxDecoration(
              // 背景色
              color: Colors.blue,
              // 圆角
              borderRadius: BorderRadius.circular(15),

              // 边框 all：针对4个边
              border: Border.all(color: Colors.amber, width: 3),
            ),
            // color: Colors.blue,

            // 旋转位移 弧度，不是角度
            transform: Matrix4.rotationZ(0.05),
            // padding: ,

            // 外边距
            margin: EdgeInsets.all(20),
            child: Text(
              'Hello Flutter',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
        ),
      ),
    );
  }
}
