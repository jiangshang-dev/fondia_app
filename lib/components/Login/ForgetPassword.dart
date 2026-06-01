import 'dart:async';
import 'package:flutter/material.dart';

class ForgetPasswordView extends StatefulWidget {
  const ForgetPasswordView({super.key});

  @override
  State<ForgetPasswordView> createState() => _ForgetPasswordViewState();
}

class _ForgetPasswordViewState extends State<ForgetPasswordView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _accountController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscureText = true; // 是否隐藏密码
  bool _isSendingCode = false; // 是否正在发送验证码
  int _countdownSeconds = 0; // 验证码倒计时
  Timer? _timer;

  // 模拟发送验证码逻辑
  void _sendVerificationCode() {
    if (_accountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请输入绑定的手机号或邮箱')),
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

    // TODO: 在这里调用发送验证码的后端接口
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('验证码已发送，请注意查收')),
    );
  }

  // 提交重置密码
  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      final account = _accountController.text;
      final code = _codeController.text;
      final newPassword = _passwordController.text;

      // TODO: 在这里对接修改/重置密码的 API 接口
      print('提交重置密码: 账号=$account, 验证码=$code, 新密码=$newPassword');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('密码重置成功，请重新登录')),
      );

      // 成功后返回上一页（登录页）
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _accountController.dispose();
    _codeController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 保持全局一致的色彩系统
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
                // 顶部标题
                const Text(
                  '找回密码',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                const SizedBox(height: 4),
                const Text(
                  '重置您的账户密码',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: primaryOrange),
                ),
                const SizedBox(height: 8),
                const Text(
                  '为了您的账户安全，请先完成身份验证',
                  style: TextStyle(fontSize: 14, color: Colors.black38),
                ),
                const SizedBox(height: 50),

                // 1. 账号输入框
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
                      hintText: '请输入绑定的手机号/邮箱',
                      hintStyle: const TextStyle(color: Colors.black26, fontSize: 15),
                      prefixIcon: const Icon(Icons.person_outline, color: primaryOrange),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 18),
                    ),
                    validator: (val) => (val == null || val.isEmpty) ? '请输入绑定的账号' : null,
                  ),
                ),
                const SizedBox(height: 20),

                // 2. 验证码输入框（带倒计时）
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
                const SizedBox(height: 20),

                // 3. 新密码输入框
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
                      hintText: '请设置新的登录密码 (至少6位)',
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
                    validator: (val) => (val == null || val.length < 6) ? '新密码长度不能少于6位' : null,
                  ),
                ),
                const SizedBox(height: 40),

                // 4. 确认重置按钮
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _handleSubmit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryOrange,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      '确 认 重 置',
                      style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 2),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}