
import 'package:flutter/material.dart';

void main() {
  runApp(MainPage());
}

// 路由跳转Material风格，只能有一个MaterialApp
class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ListPage(),// 列表页，详情页
      initialRoute: '/list',
      // 注册路由表
      routes: {
        '/detail': (context) => DetailPage(),
        '/list': (context) => ListPage(),
      },
    );
  }
}

// 有状态组件 列表页
class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('列表页'),
      ),
      body: ListView.builder(itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () {
            // 跳转到详情页
            print('跳转到详情页');
            // Navigator.of(context).pushNamed('/detail');
            // todo 命名路由传参 推荐命名路由
            Navigator.pushNamed(context, "/detail", arguments: {
              "id": index+1
            });
            // Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
            //   return DetailPage();
            // }));
          },
          child: Container(
            padding: EdgeInsets.all(10),
            color: Colors.blue,
            margin: EdgeInsets.all(10),
            height: 100,
            alignment: Alignment.center,
            child: Text('列表项 ${index+1}', style: TextStyle(color: Colors.white, fontSize: 16)),
          ),
        );
      }),
    );
  }
}

// 详情页
class DetailPage extends StatefulWidget {
  const DetailPage({super.key});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {

  String _id = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // 微任务队列中执行，比同步代码先执行
    Future.microtask((){
      // 获取路由参数
      if (ModalRoute.of(context) != null) {
        // 能获取到路由参数
        print('路由参数');
        print(ModalRoute.of(context)!.settings.arguments);
        Map<String, dynamic> params = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
        print(params['id']);
        _id = params['id'].toString();
        setState(() {});
      } else {
        // 无路由参数
        print('获取不到路由参数');
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('详情页'),
      ),
      body: Center(
        child: Column(
          children: [
            TextButton(
                onPressed: () {
                  // 返回上一页
                  Navigator.pop(context);
                },
                child: Text('返回上一个页面')
            ),

            TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/list");
                },
                // 页面路由传参数
                child: Text('去列表页$_id')
            )
          ],
        )
      )
    );
  }
}


