import 'package:flutter/material.dart';
import 'package:fondia/components/common/CardInputField.dart';
import 'package:fondia/components/common/FondiaAppBar.dart';
import 'package:fondia/components/common/IndentedDivider.dart';
import 'package:fondia/components/common/PrimaryButton.dart';
import 'package:fondia/components/common/ProtocolAgreementRow.dart';
import 'package:fondia/constants/AppTheme.dart';

/// 手机号绑定页面
class PhoneView extends StatefulWidget {
  const PhoneView({super.key});

  @override
  State<PhoneView> createState() => _PhoneViewState();
}

class _PhoneViewState extends State<PhoneView> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();

  bool _isAgreed = false;
  int _countdownTime = 0;

  void _startCountdown() {
    if (_phoneController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请输入手机号')),
      );
      return;
    }
    if (_countdownTime == 0) {
      setState(() => _countdownTime = 60);
      Future.doWhile(() async {
        await Future.delayed(const Duration(seconds: 1));
        if (!mounted) return false;
        setState(() => _countdownTime--);
        return _countdownTime > 0;
      });
      // TODO: 调用发送验证码 API
    }
  }

  void _handleSubmit() {
    if (!_isAgreed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请先勾选并阅读用户协议与隐私政策')),
      );
      return;
    }
    // TODO: 对接绑定接口
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('绑定成功')),
    );
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundCream,
      appBar: const FondiaAppBar(title: '手机号绑定'),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const Padding(
                    padding: EdgeInsets.only(left: 4, bottom: 12),
                    child: Text(
                      '绑定安全手机',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(AppRadius.card),
                    ),
                    child: Column(
                      children: [
                        CardInputField(
                          icon: Icons.phone_android_rounded,
                          controller: _phoneController,
                          hintText: '请输入手机号码',
                          keyboardType: TextInputType.phone,
                          suffix: const Text('+86', style: TextStyle(color: AppColors.textHint, fontSize: 15)),
                        ),
                        const IndentedDivider(),
                        CardInputField(
                          icon: Icons.lock_outline_rounded,
                          controller: _codeController,
                          hintText: '请输入验证码',
                          keyboardType: TextInputType.number,
                          suffix: GestureDetector(
                            onTap: _startCountdown,
                            child: Text(
                              _countdownTime > 0 ? '${_countdownTime}s后重发' : '获取验证码',
                              style: TextStyle(
                                color: _countdownTime > 0 ? AppColors.textHint : AppColors.primary,
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  ProtocolAgreementRow(
                    value: _isAgreed,
                    onChanged: (v) => setState(() => _isAgreed = v),
                    style: ProtocolCheckboxStyle.checkbox,
                    fontSize: 13,
                    suffixText: '，授权应用绑定该手机号用于账号安全验证。',
                  ),
                  const SizedBox(height: 32),
                  PrimaryButton(
                    text: '确定绑定',
                    height: 50,
                    borderRadius: AppRadius.button,
                    fontSize: 16,
                    letterSpacing: 0,
                    elevation: 0,
                    onPressed: _handleSubmit,
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
