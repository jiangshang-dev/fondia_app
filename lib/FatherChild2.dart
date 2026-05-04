import 'package:flutter/material.dart';

void main() {
  runApp(MainPage());
}

// 有状态父组件
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

// 父组件
class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    List<String> _list = [
      "京酱肉丝",
      "牛排",
      "披萨",
      "对夹",
      "锅包肉",
      "饭包",
      "蒸饺",
      "炸酱面",
      "烤鸭",
    ];

    return MaterialApp(
      // Scaffold: 脚手架
      home: Scaffold(
        appBar: AppBar(title: const Text('FatherChild2')),
        body: GridView.count(
          padding: EdgeInsets.all(10),
          mainAxisSpacing: 10, // 行间距
          crossAxisCount: 2, // 列数
          crossAxisSpacing: 10, // 列间距
          children: List.generate(_list.length, (index) {
            // 传入数据 父传子
            return Child(foodName: _list[index]); // 返回整个子组件
          }),
        ),
      ),
    );
  }
}

// 有状态子组件
class Child extends StatefulWidget {

  final String foodName;
  const Child({super.key, required this.foodName});

  @override
  State<Child> createState() => _ChildState();
}

class _ChildState extends State<Child> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      alignment: Alignment.center,
      child: Text(
        widget.foodName,
        style: TextStyle(fontSize: 20, color: Colors.white),
      ),
    );
  }
}
