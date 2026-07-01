// 管理路由
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:fondia/pages/Login/index.dart';
import 'package:fondia/pages/Main/index.dart';

// 返回app跟级组件
Widget getRootWidget() {
  return MaterialApp(
    locale: const Locale('zh', 'CN'),
    localizationsDelegates: const [
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: const [
      Locale('zh', 'CN'),
      Locale('en', 'US'),
    ],
    // 初始路由
    initialRoute: "/",
    // Map<String, Widget Function(BuildContext)> routes = const <String, WidgetBuilder>{}
    // 命名路由
    routes: getRootRoutes()
  );
}

// 返回该app的路由配置
Map<String, Widget Function(BuildContext)> getRootRoutes() {

  return {
    "/": (context) => MainPage(), // 主页路由
    "/login": (context) => LoginPage(), // 登录页
  };

}
