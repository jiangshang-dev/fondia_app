import 'package:flutter/material.dart';
import 'package:fondia/components/Login/ForgetPassword.dart';

class PasswordLoginView extends StatefulWidget {
  const PasswordLoginView({super.key});

  @override
  State<PasswordLoginView> createState() => _PasswordLoginViewState();
}

class _PasswordLoginViewState extends State<PasswordLoginView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _accountController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isAgreed = false; // 是否同意协议
  bool _obscureText = true; // 是否隐藏密码

  // 登录处理
  void _handleLogin() {
    if (!_isAgreed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请先阅读并同意用户协议和隐私政策')),
      );
      return;
    }

    if (_formKey.currentState!.validate()) {
      final account = _accountController.text;
      final password = _passwordController.text;

      // TODO: 在这里对接你的账号密码登录接口
      print('正在登录... 账号: $account, 密码: $password');
    }
  }

  @override
  void dispose() {
    _accountController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 严格对照 image_fcb123_2.png 的色彩系统
    const primaryOrange = Color(0xFFFF7433);
    const backgroundColor = Color(0xFFFFF9F5);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                // 顶部欢迎语标题
                const Text(
                  '欢迎来到',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                const SizedBox(height: 4),
                const Text(
                  '密码登录',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: primaryOrange),
                ),
                const SizedBox(height: 8),
                const Text(
                  '让做饭更简单，爱生活，爱美食',
                  style: TextStyle(fontSize: 14, color: Colors.black38),
                ),
                const SizedBox(height: 50),

                // 账号/邮箱输入框
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.02),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      )
                    ],
                  ),
                  child: TextFormField(
                    controller: _accountController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: '请输入手机号/邮箱/用户名',
                      hintStyle: const TextStyle(color: Colors.black26, fontSize: 15),
                      prefixIcon: const Icon(Icons.person_outline, color: primaryOrange),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 18),
                    ),
                    validator: (val) => (val == null || val.isEmpty) ? '请输入登录账号' : null,
                  ),
                ),
                const SizedBox(height: 20),

                // 密码输入框
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.02),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      )
                    ],
                  ),
                  child: TextFormField(
                    controller: _passwordController,
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                      hintText: '请输入登录密码',
                      hintStyle: const TextStyle(color: Colors.black26, fontSize: 15),
                      prefixIcon: const Icon(Icons.lock_open_outlined, color: primaryOrange),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                          color: Colors.black26,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 18),
                    ),
                    validator: (val) => (val == null || val.length < 6) ? '密码长度不能少于6位' : null,
                  ),
                ),

                // 忘记密码微调辅助按钮
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10.0, right: 12.0),
                    child: TextButton(
                      onPressed: () {
                        // TODO: 跳转至找回密码页面
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => const ForgetPasswordView()),
                              (route) => false,
                        );
                      },
                      style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: const Size(50, 30)),
                      child: const Text(
                        '忘记密码？',
                        style: TextStyle(color: Colors.black38, fontSize: 13),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // 登录大按钮
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _handleLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryOrange,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      '登 录',
                      style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                // 隐私协议与条款（完美匹配 image_fcb123_2.png 底部）
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isAgreed = !_isAgreed;
                        });
                      },
                      child: Icon(
                        _isAgreed ? Icons.check_circle : Icons.radio_button_unchecked,
                        size: 18,
                        color: _isAgreed ? primaryOrange : Colors.black26,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Text('我已阅读并同意 ', style: TextStyle(color: Colors.black38, fontSize: 12)),
                    GestureDetector(
                      onTap: () {/* 跳转用户协议 */},
                      child: const Text('《用户协议》', style: TextStyle(color: primaryOrange, fontSize: 12)),
                    ),
                    const Text(' 和 ', style: TextStyle(color: Colors.black38, fontSize: 12)),
                    GestureDetector(
                      onTap: () {/* 跳转隐私政策 */},
                      child: const Text('《隐私政策》', style: TextStyle(color: primaryOrange, fontSize: 12)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}