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
        body: Stack(
          children: [
            // 滚动
            SingleChildScrollView(
              // 滚动
              controller: _controller,
              padding: EdgeInsets.all(20),
              child: Column(
                children: List.generate(100, (index) {
                  return Container(
                    margin: EdgeInsets.only(top: 10),
                    // margin: EdgeInsets.all(5),
                    width: double.infinity,
                    color: Colors.blue,
                    height: 100,
                    // 居中
                    alignment: Alignment.center,
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  );
                }),

                /*children: [
                    Container(
                      width: double.infinity,
                      color: Colors.blue,
                      height: 100,
                      // 居中
                      alignment: Alignment.center,
                      child: Text('1', style: TextStyle(fontSize: 20, color: Colors.white)),
                    )
                  ],*/
              ),
            ),

            // 添加一个固定在顶部的标题
            // 堆叠组件
            Positioned(
              top: 10,
              right: 10,
              child: GestureDetector(
                onTap: () {
                  print('去底');
                  // _controller.jumpTo(_controller.position.maxScrollExtent);
                  // 带动画效果
                  _controller.animateTo(_controller.position.maxScrollExtent,
                      duration: Duration(seconds: 3), curve: Curves.easeIn);
                },
                child: Container(
                  // 注意：decoration和color不能共存
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(40 ),
                  ),
                  alignment: Alignment.center,
                  width: 90,
                  height: 90,
                  // color: Colors.red,
                  child: Text(
                    '去底部',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              )
            ),


            Positioned(
              bottom: 10,
              right: 10,
              // GestureDetector点击事件
              child: GestureDetector(
                onTap: () {
                  print('去顶');
                  // _controller.jumpTo(_controller.position.minScrollExtent);
                  // 不带动画
                  // _controller.jumpTo(0);
                  // 带动画效果
                  _controller.animateTo(0,
                      duration: Duration(seconds: 1), curve: Curves.bounceIn);
                },
                child: Container(
                  // 注意：decoration和color不能共存
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(40 ),
                  ),
                  alignment: Alignment.center,
                  width: 90,
                  height: 90,
                  // color: Colors.red,
                  child: Text(
                    '去顶部',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              )
            ),

          ],
        ),
      ),
    );
  }
}
