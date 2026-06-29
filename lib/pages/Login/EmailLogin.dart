import 'package:flutter/material.dart';
import 'package:fondia/api/login.dart';
import 'package:fondia/components/common/FondiaAppBar.dart';
import 'package:fondia/components/common/LoginWelcomeHeader.dart';
import 'package:fondia/components/common/PrimaryButton.dart';
import 'package:fondia/components/common/ProtocolAgreementRow.dart';
import 'package:fondia/components/common/RoundedFormField.dart';
import 'package:fondia/components/common/VerificationCodeField.dart';
import 'package:fondia/constants/AppTheme.dart';
import 'package:fondia/pages/Main/index.dart';
import 'package:fondia/stores/TokenManager.dart';

class EmailLoginView extends StatefulWidget {
  const EmailLoginView({super.key});

  @override
  State<EmailLoginView> createState() => _EmailLoginViewState();
}

class _EmailLoginViewState extends State<EmailLoginView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();

  bool _isAgreed = false;

  Future<bool> _sendVerificationCode() async {
    final email = _emailController.text;
    if (email.isEmpty || !email.contains('@')) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('请输入正确的邮箱地址')),
        );
      }
      return false;
    }

    try {
      await LoginApi.sendEmailCode(email, 'login');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('验证码已发送至您的邮箱')),
        );
      }
      return true;
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('发送验证码失败: ${e.toString()}')),
        );
      }
      return false;
    }
  }

  Future<void> _handleLogin() async {
    if (!_isAgreed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请先阅读并同意用户协议和隐私政策')),
      );
      return;
    }

    if (!_formKey.currentState!.validate()) return;

    final email = _emailController.text;
    final code = _codeController.text;

    try {
      final result = await LoginApi.emailLogin(email, code);
      if (result != null) {
        await tokenManager.setToken(result['token'] ?? '');
        await tokenManager.saveUserInfo(result['userInfo'] ?? {});

        if (mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const MainPage()),
            (route) => false,
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('登录失败: ${e.toString()}')),
        );
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _codeController.dispose();
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
                const LoginWelcomeHeader(line2: '邮箱登录'),
                const SizedBox(height: 50),
                RoundedFormField(
                  controller: _emailController,
                  hintText: '请输入邮箱地址',
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: (val) =>
                      (val == null || !val.contains('@')) ? '请输入有效的邮箱' : null,
                ),
                const SizedBox(height: 20),
                VerificationCodeField(
                  controller: _codeController,
                  onSendCode: _sendVerificationCode,
                  validator: (val) =>
                      (val == null || val.length < 4) ? '请输入正确的验证码' : null,
                ),
                const SizedBox(height: 40),
                PrimaryButton(text: '登 录', onPressed: _handleLogin),
                const SizedBox(height: 30),
                ProtocolAgreementRow(
                  value: _isAgreed,
                  onChanged: (v) => setState(() => _isAgreed = v),
                  center: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
