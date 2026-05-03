import 'package:flutter/material.dart';

void main() {
  runApp(MainPage());
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    print("无状态组件的构建");
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('头部区域')),
        body: Container(
          child: Center(
            child:
                // 点击事件
                /*GestureDetector(
                  // 长按
                  onLongPress: () {
                    print('长按该区域');
                  },
                  // 单击
                  onTap: () {
                    print('点击该区域');
                  },
                  // 双击
                  onDoubleTap: (){
                    print('双击该区域');
                  },
                ),*/
               // 按钮事件
               TextButton(onPressed: () {
                 print('点了一下按钮');
               }, child: Text('按钮'))
          ),
        ),
        bottomNavigationBar: Container(
          child: Center(child: Text('底部区域')),
          height: 80,
        ),
      ),
    );
  }
}
