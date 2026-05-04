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

    List<Widget> getList() {
      return List.generate(10, (index){
        return Container(
          margin: EdgeInsets.all(5),
          color: Colors.red,
          width: 100,
          height: 100,
          child: Text("$index"),
        );
      });
    }

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('头部区域')),
        // Center 充满了父组件
        body: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.amber,
          // width: 100,
          // height: 100,
          child: Wrap(
            spacing: 10, // 主轴
            runSpacing: 10, // 交叉轴
              alignment: WrapAlignment.spaceBetween,
            children: getList()
          ),
        )
      ),
    );
  }
}
