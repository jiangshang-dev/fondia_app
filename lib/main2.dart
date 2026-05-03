/*
  Flutter自定义组件-无状态组件和有状态组件
  ●定义：根据自己特定的需求创建自己的Widget
  ●分类：Flutter分为无状态组件和有状态组件
 */
import 'package:flutter/material.dart';

// 无状态组件 StatelessWidget
// 有状态组件
void main() {
  runApp(MainPage());
}

// 自定义组件：无状态组件 StatelessWidget
class MainPage extends StatelessWidget {
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
