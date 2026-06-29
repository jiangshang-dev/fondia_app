import 'package:flutter/material.dart';
import 'package:fondia/components/common/FondiaAppBar.dart';
import 'package:fondia/components/common/LoginWelcomeHeader.dart';
import 'package:fondia/components/common/PrimaryButton.dart';
import 'package:fondia/components/common/RoundedFormField.dart';
import 'package:fondia/components/common/VerificationCodeField.dart';
import 'package:fondia/constants/AppTheme.dart';

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

  bool _obscureText = true;

  Future<bool> _sendVerificationCode() async {
    if (_accountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请输入绑定的手机号或邮箱')),
      );
      return false;
    }
    // TODO: 对接发送验证码 API
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('验证码已发送，请注意查收')),
      );
    }
    return true;
  }

  void _handleSubmit() {
    if (!_formKey.currentState!.validate()) return;

    // TODO: 对接重置密码 API
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('密码重置成功，请重新登录')),
    );
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _accountController.dispose();
    _codeController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWarm,
      appBar: const FondiaAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const LoginWelcomeHeader(
                  line1: '找回密码',
                  line2: '重置您的账户密码',
                  subtitle: '为了您的账户安全，请先完成身份验证',
                ),
                const SizedBox(height: 50),
                RoundedFormField(
                  controller: _accountController,
                  hintText: '请输入绑定的手机号/邮箱',
                  prefixIcon: Icons.person_outline,
                  keyboardType: TextInputType.emailAddress,
                  validator: (val) =>
                      (val == null || val.isEmpty) ? '请输入绑定的账号' : null,
                ),
                const SizedBox(height: 20),
                VerificationCodeField(
                  controller: _codeController,
                  onSendCode: _sendVerificationCode,
                  validator: (val) =>
                      (val == null || val.length < 4) ? '请输入正确的验证码' : null,
                ),
                const SizedBox(height: 20),
                RoundedFormField(
                  controller: _passwordController,
                  hintText: '请设置新的登录密码 (至少6位)',
                  prefixIcon: Icons.lock_open_outlined,
                  obscureText: _obscureText,
                  validator: (val) =>
                      (val == null || val.length < 6) ? '新密码长度不能少于6位' : null,
                  suffix: IconButton(
                    icon: Icon(
                      _obscureText
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: AppColors.textDisabled,
                    ),
                    onPressed: () => setState(() => _obscureText = !_obscureText),
                  ),
                ),
                const SizedBox(height: 40),
                PrimaryButton(text: '确 认 重 置', onPressed: _handleSubmit),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
