import 'package:flutter/material.dart';
import 'package:fondia/api/login.dart';
import 'package:fondia/components/common/FondiaAppBar.dart';
import 'package:fondia/components/common/LoginWelcomeHeader.dart';
import 'package:fondia/components/common/PrimaryButton.dart';
import 'package:fondia/components/common/ProtocolAgreementRow.dart';
import 'package:fondia/components/common/RoundedFormField.dart';
import 'package:fondia/constants/AppTheme.dart';
import 'package:fondia/pages/Login/ForgetPassword.dart';
import 'package:fondia/pages/Main/index.dart';
import 'package:fondia/utils/DioRequest.dart';

class PasswordLoginView extends StatefulWidget {
  const PasswordLoginView({super.key});

  @override
  State<PasswordLoginView> createState() => _PasswordLoginViewState();
}

class _PasswordLoginViewState extends State<PasswordLoginView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _accountController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isAgreed = false;
  bool _obscureText = true;

  Future<void> _handleLogin() async {
    if (!_isAgreed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请先阅读并同意用户协议和隐私政策')),
      );
      return;
    }

    if (!_formKey.currentState!.validate()) return;

    try {
      final result = await LoginApi.passwordLogin(
        _accountController.text.trim(),
        _passwordController.text,
      );
      if (result != null) {
        await LoginApi.saveLoginResult(result);

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
          SnackBar(content: Text(dioErrorMessage(e, fallback: '登录失败，请检查账号和密码'))),
        );
      }
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
                const LoginWelcomeHeader(line2: '密码登录'),
                const SizedBox(height: 50),
                RoundedFormField(
                  controller: _accountController,
                  hintText: '请输入手机号/邮箱/用户名',
                  prefixIcon: Icons.person_outline,
                  keyboardType: TextInputType.emailAddress,
                  validator: (val) =>
                      (val == null || val.isEmpty) ? '请输入登录账号' : null,
                ),
                const SizedBox(height: 20),
                RoundedFormField(
                  controller: _passwordController,
                  hintText: '请输入登录密码',
                  prefixIcon: Icons.lock_open_outlined,
                  obscureText: _obscureText,
                  validator: (val) =>
                      (val == null || val.length < 6) ? '密码长度不能少于6位' : null,
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
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10, right: 12),
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ForgetPasswordView(),
                          ),
                        );
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(50, 30),
                      ),
                      child: const Text(
                        '忘记密码？',
                        style: TextStyle(color: AppColors.textHint, fontSize: 13),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                PrimaryButton(text: '登 录', onPressed: _handleLogin),
                const SizedBox(height: 40),
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
