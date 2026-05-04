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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Scaffold: 脚手架
      home: Scaffold(
        appBar: AppBar(title: const Text('FatherChild2')),
        body: GridView.count(
          padding: EdgeInsets.all(10),
          mainAxisSpacing: 10,
          // 行间距
          crossAxisCount: 2,
          // 列数
          crossAxisSpacing: 10,
          // 列间距
          children: List.generate(_list.length, (index) {
            // 传入数据 父传子
            return Child(
              foodName: _list[index], // 食物名称列表
              index:  index,  // 索引
              delFood: (i) { // 删除方法
                print('删除成功-$index');
                _list.removeAt(i);
                setState(() {});
              }
            ); // 返回整个子组件
          }),
        ),
      ),
    );
  }
}

// 有状态子组件
class Child extends StatefulWidget {
  final String foodName;
  final int index;
  // 声明函数属性
  final Function(int index) delFood;

  const Child({super.key, required this.foodName, required this.index, required this.delFood});

  @override
  State<Child> createState() => _ChildState();
}

class _ChildState extends State<Child> {

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        Container(
          color: Colors.blue,
          alignment: Alignment.center,
          child: Text(
            widget.foodName,
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ),

        IconButton(
          color: Colors.red,
          onPressed: () {
            // 删除 获取索引
            print('删除${widget.index}');
            widget.delFood(widget.index);
          },
          icon: Icon(Icons.delete),
        )
      ],
    );
  }
}
