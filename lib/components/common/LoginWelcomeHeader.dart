import 'package:flutter/material.dart';
import 'package:fondia/constants/AppTheme.dart';

/// 登录页欢迎标题区
class LoginWelcomeHeader extends StatelessWidget {
  const LoginWelcomeHeader({
    super.key,
    this.line1 = '欢迎来到',
    required this.line2,
    this.subtitle = '让做饭更简单，爱生活，爱美食',
  });

  final String line1;
  final String line2;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          line1,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          line2,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 8),
          Text(
            subtitle!,
            style: const TextStyle(fontSize: 14, color: AppColors.textHint),
          ),
        ],
      ],
    );
  }
}
