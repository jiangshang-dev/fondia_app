import 'package:flutter/material.dart';
import 'package:fondia/constants/AppTheme.dart';

/// 首页区块标题（橙色竖条 + 标题 + 可选操作）
class SectionTitleBar extends StatelessWidget {
  const SectionTitleBar({
    super.key,
    required this.title,
    this.actionText,
    this.onActionTap,
    this.fontSize = 22,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  });

  final String title;
  final String? actionText;
  final VoidCallback? onActionTap;
  final double fontSize;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
        children: [
          Container(
            width: 4,
            height: 18,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          if (actionText != null)
            GestureDetector(
              onTap: onActionTap,
              child: Text(
                actionText!,
                style: const TextStyle(fontSize: 13, color: AppColors.textHint),
              ),
            ),
        ],
      ),
    );
  }
}
