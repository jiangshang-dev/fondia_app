
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

  List<Map<String, dynamic>> _list = [];
  void _getChannels() async {
    Dioutils dio = Dioutils();
    var result = await dio.get('/v1_0/channels');
    print(result.data);
    var res = result.data as Map<String, dynamic>;
    print(res['data']['channels'][0]);
    print(res['data']['channels']);

    List data = res['data']['channels'] as List;
    _list = data.cast<Map<String, dynamic>>();
    setState(() {});
    print(_list);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('频道管理'),
        ),
        body: GridView.extent(
          padding: EdgeInsets.all(10),
          maxCrossAxisExtent: 140,// 宽度
          mainAxisSpacing: 10, // 行间距
          crossAxisSpacing: 10, // 列间距
          childAspectRatio: 3, // 宽高比
          children: List.generate(_list.length , (index) {
            return ChannelItem(title: _list[index]);
          }),
        )
      ),
    );
  }
}

// 用来绘制每个频道的UI内容
class ChannelItem extends StatelessWidget {
  final Map<String,dynamic> title;
  const ChannelItem({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      alignment: Alignment.center,
      child: Text(title['name'], style: TextStyle(color: Colors.white, fontSize: 14)),
    );
  }
}



