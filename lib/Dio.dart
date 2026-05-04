
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fondia/DioUtils.dart';

void main() {
  // Dio().get("https://geek.itheima.net/v1_0/channels").then((res) {
  //   print('======');
  //   print(res);
  // });

  runApp(MainPage());
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // 发起网络请求
    _getChannels(); // 获取频道数据
  }

  void _getChannels() async {
    Dioutils dio = Dioutils();
    var result = await dio.get('/v1_0/channels');
    print(result.data);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Dio'),
        ),
        body: Center(
          child: Text('Dio'),
        ),
      ),
    );
  }
}


