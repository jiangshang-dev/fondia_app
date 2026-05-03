import 'package:flutter/material.dart';

/*
  加减事件按钮小示例
 */
void main() {
  runApp(MainPage());
}

// 创建有状态的组件
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // 声明变量
  int count = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Row(
            children: [
              TextButton(
                onPressed: () {
                  setState(() {
                    count += 1;
                    print(count);
                  });
                },
                child: Text('加'),
              ),
              Text(count.toString()),
              TextButton(
                onPressed: () {
                  setState(() {
                    count -= 1;
                    print(count);
                  });
                },
                child: Text('减'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
