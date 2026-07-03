import 'package:flutter/material.dart';
import 'package:fondia/api/user.dart';
import 'package:fondia/components/common/FondiaAppBar.dart';
import 'package:fondia/components/common/PrimaryButton.dart';
import 'package:fondia/components/common/RoundedFormField.dart';
import 'package:fondia/constants/AppTheme.dart';
import 'package:fondia/utils/DioRequest.dart';

class ChangePasswordView extends StatefulWidget {
  const ChangePasswordView({super.key});

  @override
  State<ChangePasswordView> createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<ChangePasswordView> {
  final _formKey = GlobalKey<FormState>();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscureOld = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;
  bool _submitting = false;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _submitting = true);
    try {
      await UserApi.changePassword(
        oldPassword: _oldPasswordController.text,
        newPassword: _newPasswordController.text,
        confirmPassword: _confirmPasswordController.text,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('密码修改成功')),
      );
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(dioErrorMessage(e, fallback: '密码修改失败'))),
      );
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundCream,
      appBar: const FondiaAppBar(
        title: '修改密码',
        backgroundColor: AppColors.backgroundCream,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xfffdf2e9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    '为保障账号安全，修改密码后请使用新密码重新登录。',
                    style: TextStyle(fontSize: 13, color: Color(0xFF8A5A2B), height: 1.5),
                  ),
                ),
                const SizedBox(height: 20),
                RoundedFormField(
                  controller: _oldPasswordController,
                  hintText: '请输入旧密码（首次设置可不填）',
                  prefixIcon: Icons.lock_outline,
                  obscureText: _obscureOld,
                  suffix: IconButton(
                    icon: Icon(
                      _obscureOld ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                      color: AppColors.textDisabled,
                    ),
                    onPressed: () => setState(() => _obscureOld = !_obscureOld),
                  ),
                ),
                const SizedBox(height: 16),
                RoundedFormField(
                  controller: _newPasswordController,
                  hintText: '请输入新密码（至少6位）',
                  prefixIcon: Icons.lock_open_outlined,
                  obscureText: _obscureNew,
                  validator: (val) =>
                      (val == null || val.length < 6) ? '新密码长度不能少于6位' : null,
                  suffix: IconButton(
                    icon: Icon(
                      _obscureNew ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                      color: AppColors.textDisabled,
                    ),
                    onPressed: () => setState(() => _obscureNew = !_obscureNew),
                  ),
                ),
                const SizedBox(height: 16),
                RoundedFormField(
                  controller: _confirmPasswordController,
                  hintText: '请再次输入新密码',
                  prefixIcon: Icons.lock_open_outlined,
                  obscureText: _obscureConfirm,
                  validator: (val) {
                    if (val == null || val.isEmpty) return '请确认新密码';
                    if (val != _newPasswordController.text) return '两次输入密码不一致';
                    return null;
                  },
                  suffix: IconButton(
                    icon: Icon(
                      _obscureConfirm ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                      color: AppColors.textDisabled,
                    ),
                    onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
                  ),
                ),
                const SizedBox(height: 32),
                PrimaryButton(
                  text: _submitting ? '提交中...' : '确认修改',
                  onPressed: _submitting ? null : _submit,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
