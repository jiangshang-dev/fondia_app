import 'package:flutter/material.dart';
import 'package:fondia/constants/AppTheme.dart';

/// 设置页跳转列表行
class SettingsListTile extends StatelessWidget {
  const SettingsListTile({
    super.key,
    required this.icon,
    required this.title,
    this.trailingText,
    this.trailingWidget,
    this.onTap,
    this.showArrow = true,
  });

  final IconData icon;
  final String title;
  final String? trailingText;
  final Widget? trailingWidget;
  final VoidCallback? onTap;
  final bool showArrow;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      minLeadingWidth: 20,
      leading: Icon(icon, color: AppColors.primaryLight, size: 22),
      title: Text(
        title,
        style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailingText != null)
            Text(
              trailingText!,
              style: const TextStyle(fontSize: 13, color: Colors.grey),
            ),
          if (trailingWidget != null) trailingWidget!,
          if (showArrow) ...[
            const SizedBox(width: 4),
            const Icon(Icons.arrow_forward_ios, size: 12, color: Colors.grey),
          ],
        ],
      ),
      onTap: onTap,
    );
  }
}
