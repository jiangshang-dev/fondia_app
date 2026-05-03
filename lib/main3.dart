/*
  有状态组件-StatefulWidget
 */
import 'package:flutter/material.dart';

void main() {
  runApp(MainPage());
}

// 有状态组件-StatefulWidget 第一个类对外
class MainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MainPageState();
  }

}

// 带_对内 相当于private
// 第二个类 内部类 负责管理数据 处理业务逻辑，并且渲染视图
class _MainPageState extends State<MainPage>{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '自定义组件-无状态组件',
      home: Scaffold(
        appBar: AppBar(
          title: Text('头部区域'),
        ),
        body: Container(
          child: Center(
            child: Text('中部区域'),
          ),
        ),
        bottomNavigationBar: Container(
          child: Center(
            child: Text('底部区域'),
          ),
          height: 80,
        ),
      ),
    );

  }

}