import 'package:flutter/material.dart';
import 'package:fondia/api/login.dart';
import 'package:fondia/components/common/FondiaAppBar.dart';
import 'package:fondia/components/common/LoginWelcomeHeader.dart';
import 'package:fondia/components/common/PrimaryButton.dart';
import 'package:fondia/components/common/RoundedFormField.dart';
import 'package:fondia/components/common/VerificationCodeField.dart';
import 'package:fondia/constants/AppTheme.dart';
import 'package:fondia/utils/DioRequest.dart';

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
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _obscureText = true;
  bool _obscureConfirm = true;
  bool _submitting = false;

  Future<bool> _sendVerificationCode() async {
    final account = _accountController.text.trim();
    if (account.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请输入绑定的手机号或邮箱')),
      );
      return false;
    }

    try {
      await LoginApi.sendResetPasswordCode(account);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('验证码已发送，请注意查收')),
        );
      }
      return true;
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(dioErrorMessage(e, fallback: '发送验证码失败'))),
        );
      }
      return false;
    }
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('两次输入密码不一致')),
      );
      return;
    }

    setState(() => _submitting = true);
    try {
      await LoginApi.resetPassword(
        account: _accountController.text.trim(),
        code: _codeController.text.trim(),
        newPassword: _passwordController.text,
        confirmPassword: _confirmPasswordController.text,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('密码重置成功，请重新登录')),
      );
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(dioErrorMessage(e, fallback: '密码重置失败'))),
      );
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  void dispose() {
    _accountController.dispose();
    _codeController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
                const SizedBox(height: 20),
                RoundedFormField(
                  controller: _confirmPasswordController,
                  hintText: '请再次输入新密码',
                  prefixIcon: Icons.lock_open_outlined,
                  obscureText: _obscureConfirm,
                  validator: (val) {
                    if (val == null || val.isEmpty) return '请确认新密码';
                    if (val != _passwordController.text) return '两次输入密码不一致';
                    return null;
                  },
                  suffix: IconButton(
                    icon: Icon(
                      _obscureConfirm
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: AppColors.textDisabled,
                    ),
                    onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
                  ),
                ),
                const SizedBox(height: 40),
                PrimaryButton(
                  text: _submitting ? '提交中...' : '确 认 重 置',
                  onPressed: _submitting ? null : _handleSubmit,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
