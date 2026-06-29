import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fondia/constants/AppTheme.dart';

/// 验证码输入框 + 倒计时发送按钮
class VerificationCodeField extends StatefulWidget {
  const VerificationCodeField({
    super.key,
    required this.controller,
    required this.onSendCode,
    this.validator,
    this.countdownSeconds = 60,
    this.hintText = '请输入验证码',
  });

  final TextEditingController controller;
  /// 返回 true 表示发送成功，将自动开始倒计时
  final Future<bool> Function() onSendCode;
  final FormFieldValidator<String>? validator;
  final int countdownSeconds;
  final String hintText;

  @override
  State<VerificationCodeField> createState() => _VerificationCodeFieldState();
}

class _VerificationCodeFieldState extends State<VerificationCodeField> {
  bool _isSending = false;
  int _remaining = 0;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startCountdown() {
    setState(() {
      _isSending = true;
      _remaining = widget.countdownSeconds;
    });
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        if (_remaining > 1) {
          _remaining--;
        } else {
          _timer?.cancel();
          _remaining = 0;
          _isSending = false;
        }
      });
    });
  }

  Future<void> _handleSend() async {
    final success = await widget.onSendCode();
    if (!mounted) return;
    if (success) {
      _startCountdown();
    } else {
      _timer?.cancel();
      setState(() {
        _remaining = 0;
        _isSending = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: widget.controller,
              keyboardType: TextInputType.number,
              validator: widget.validator,
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: const TextStyle(
                  color: AppColors.textDisabled,
                  fontSize: 15,
                ),
                prefixIcon: const Icon(
                  Icons.shield_outlined,
                  color: AppColors.primary,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 18),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: TextButton(
              onPressed: _isSending ? null : _handleSend,
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(
                _isSending ? '$_remaining秒后重新获取' : '获取验证码',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: _isSending ? Colors.grey : AppColors.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
