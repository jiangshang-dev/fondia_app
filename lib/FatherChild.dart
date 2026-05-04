import 'package:flutter/material.dart';

void main() {
  runApp(MainPage());
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(

          body: Container(
            alignment: Alignment.center,
            child: Column(
              children: [
                Text('父组件', style: TextStyle(color: Colors.blue, fontSize: 30)),
                // 调用子组件
                // 无状态
                Child(message: '小明'),
                // 调用子组件 有状态
                Child2(message: '小王'),
              ],
            ),
          )
      ),
    );
  }
}

// 无状态的子组件
class Child extends StatelessWidget {
  final String? message;
  // 在构造函数中接收参数
  const Child({Key? key, this.message}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('子组件$message', style: TextStyle(color: Colors.red, fontSize: 18),),
    );
  }

}

// 有状态的子组件
// 对外的类接收属性，对内的类获取对应属性
class Child2 extends StatefulWidget {

  final String message;
  const Child2({super.key, required this.message});

  @override
  State<Child2> createState() => _Child2State();
}

// 对内的类获取对应属性
class _Child2State extends State<Child2> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('子组件${widget.message}', style: TextStyle(color: Colors.red, fontSize: 18),),
    );
  }
}



