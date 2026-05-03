/*
  flutter的默认Material库
  ●Material是Google公司推行的一套设计风格，有很多的设计规范，如颜色、文字排版、动画等
  ●目的：Material为Android、Web、iOS、HarmonyOS多个平台提供统一的交互和视觉体验
 */
import 'package:flutter/material.dart';

// 运行：flutter run -d web-server --web-hostname 0.0.0.0 --web-port 8088
void main() {
  runApp(MaterialApp(
    // App标题
    title: 'Flutter体验',
    // 主题色
    theme: ThemeData(
      scaffoldBackgroundColor: Colors.amberAccent
    ),
    // App骨架颜色
    // Scaffold：用于构建Material Design风格页面的核心布局组件，提供标准、灵活配置的页面骨架
    home: Scaffold(
      // 顶部应用栏
      appBar: AppBar(
        title: Text('头部信息'),
      ),
      // 内容主体
      // body: Text('中部区域'),
      // 居中先用Container
      body: Container(
        // 居中
        child: Center(
          child: Text('中部区域'),
        ),
      ),
      // 底部导航
      bottomNavigationBar: Container(
        height: 80,
        // 居中
        child: Center(
          child: Text('中部区域'),
        ),
      ),
      // 整个背景色
      // backgroundColor: Colors.green,
      // 悬浮操作按钮，触发页面主要动作
      // floatingActionButton: ,
    ),
  ));
}
