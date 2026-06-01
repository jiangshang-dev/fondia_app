import 'dart:async';
import 'package:flutter/material.dart';

class EmailLoginView extends StatefulWidget {
  const EmailLoginView({super.key});

  @override
  State<EmailLoginView> createState() => _EmailLoginViewState();
}

class _EmailLoginViewState extends State<EmailLoginView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();

  bool _isAgreed = false; // 是否同意协议
  bool _isSendingCode = false; // 是否正在发送验证码
  int _countdownSeconds = 0; // 验证码倒计时
  Timer? _timer;

  // 模拟发送验证码逻辑
  void _sendVerificationCode() {
    if (_emailController.text.isEmpty || !_emailController.text.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请输入正确的邮箱地址')),
      );
      return;
    }

    setState(() {
      _isSendingCode = true;
      _countdownSeconds = 60;
    });

    // 开始倒计时
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_countdownSeconds > 1) {
          _countdownSeconds--;
        } else {
          _timer?.cancel();
          _countdownSeconds = 0;
          _isSendingCode = false;
        }
      });
    });

    // TODO: 在这里调用你的后台API发送邮件验证码
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('验证码已发送至您的邮箱')),
    );
  }

  // 登录逻辑
  void _handleLogin() {
    if (!_isAgreed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请先阅读并同意用户协议和隐私政策')),
      );
      return;
    }

    if (_formKey.currentState!.validate()) {
      // TODO: 执行登录逻辑
      final email = _emailController.text;
      final code = _codeController.text;
      print('开始登录: $email, 验证码: $code');
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _emailController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 提取UI图中的核心颜色
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
                // 标题部分（复刻UI图左上角风格）
                const Text(
                  '欢迎来到',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                const SizedBox(height: 4),
                const Text(
                  '邮箱登录',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: primaryOrange),
                ),
                const SizedBox(height: 8),
                const Text(
                  '让做饭更简单，爱生活，爱美食',
                  style: TextStyle(fontSize: 14, color: Colors.black38),
                ),
                const SizedBox(height: 50),

                // 邮箱输入框
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
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: '请输入邮箱地址',
                      hintStyle: const TextStyle(color: Colors.black26, fontSize: 15),
                      prefixIcon: const Icon(Icons.email_outlined, color: primaryOrange),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 18),
                    ),
                    validator: (val) => (val == null || !val.contains('@')) ? '请输入有效的邮箱' : null,
                  ),
                ),
                const SizedBox(height: 20),

                // 验证码输入框
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
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _codeController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: '请输入验证码',
                            hintStyle: const TextStyle(color: Colors.black26, fontSize: 15),
                            prefixIcon: const Icon(Icons.shield_outlined, color: primaryOrange),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(vertical: 18),
                          ),
                          validator: (val) => (val == null || val.length < 4) ? '请输入正确的验证码' : null,
                        ),
                      ),
                      // 发送验证码按钮
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: TextButton(
                          onPressed: _isSendingCode ? null : _sendVerificationCode,
                          style: TextButton.styleFrom(
                            foregroundColor: primaryOrange,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          ),
                          child: Text(
                            _isSendingCode ? '重新发送($_countdownSeconds)' : '获取验证码',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: _isSendingCode ? Colors.grey : primaryOrange,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),

                // 登录按钮
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
                const SizedBox(height: 30),

                // 隐私政策勾选（完全复刻UI图底部的样式）
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