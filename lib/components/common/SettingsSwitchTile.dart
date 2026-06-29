import 'package:flutter/material.dart';
import 'package:fondia/constants/AppTheme.dart';

/// 设置页开关列表行
class SettingsSwitchTile extends StatelessWidget {
  const SettingsSwitchTile({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.onChanged,
    this.subtitle,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      secondary: Icon(icon, color: AppColors.primaryLight, size: 22),
      title: Text(
        title,
        style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
      ),
      subtitle: subtitle != null
          ? Text(subtitle!, style: const TextStyle(fontSize: 12))
          : null,
      value: value,
      onChanged: onChanged,
      activeTrackColor: AppColors.primaryLight,
    );
  }
}
