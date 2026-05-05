
import 'package:flutter/material.dart';

void main() {
  runApp(MainPage());
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/goodsList',
      // todo 注册路由表
      routes: {
        // 登录页和购物车页不在路由表里
        '/goodsList': (context) => GoodsList(),

      },
      // 在routes没有匹配的路由，会调用此方法
      onGenerateRoute: (RouteSettings settings) {
        print(settings.name);
        // 判断是不是购物车列表页面
        if (settings.name == '/carList') {
          bool isLogin = true;
          if (isLogin) {
            return MaterialPageRoute(builder: (context) {
              return CarList();
            });
          } else {
            return MaterialPageRoute(builder: (context) {
              return LoginPage();
            });
          }
        }
      },
      // 处理404页
      onUnknownRoute: (RouteSettings settings) {
        return MaterialPageRoute(builder: (context) {
          return NotFoundPage();
        });
      },

    );
  }
}

class GoodsList extends StatefulWidget {
  const GoodsList({super.key});

  @override
  State<GoodsList> createState() => _GoodsListState();
}

class _GoodsListState extends State<GoodsList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 创建导航栏
      appBar: AppBar(
        title: Text('商品列表'),
      ),
      // 主体
      body: Center(
        child: TextButton(
            onPressed: (){
              Navigator.pushNamed(context, "/carList11");
            },
            child: Text('加入购物车')
        ),
      ),
    );
  }
}

// 购物车列表
class CarList extends StatefulWidget {
  const CarList({super.key});

  @override
  State<CarList> createState() => _CarListState();
}

class _CarListState extends State<CarList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 创建导航栏
      appBar: AppBar(
        title: Text('购物车列表'),
      ),
      // 主体
      body: Center(
        child: TextButton(
            onPressed: (){},
            child: Text('购物车')
        ),
      ),
    );
  }
}

//登录页面
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 创建导航栏
      appBar: AppBar(
        title: Text('登录'),
      ),
      // 主体
      body: Center(
        child: TextButton(
            onPressed: (){},
            child: Text('登录')
        ),
      ),
    );
  }
}

// 404页面
class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset('lib/images/404.jpg', width: 300, height: 400,),
    );
    // return Center(child: Text('404'),);
  }
}




