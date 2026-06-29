import 'package:flutter/material.dart';
import 'package:fondia/constants/AppTheme.dart';

/// 卡片内行式输入框（手机号绑定等场景）
class CardInputField extends StatelessWidget {
  const CardInputField({
    super.key,
    required this.icon,
    required this.controller,
    required this.hintText,
    this.keyboardType = TextInputType.text,
    this.suffix,
  });

  final IconData icon;
  final TextEditingController controller;
  final String hintText;
  final TextInputType keyboardType;
  final Widget? suffix;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 22, color: AppColors.primary),
          const SizedBox(width: 14),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              style: const TextStyle(fontSize: 15, color: AppColors.textSecondary),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: const TextStyle(color: AppColors.textHint, fontSize: 15),
                border: InputBorder.none,
              ),
            ),
          ),
          if (suffix != null) suffix!,
        ],
      ),
    );
  }
}
