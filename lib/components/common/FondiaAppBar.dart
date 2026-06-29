import 'package:flutter/material.dart';
import 'package:fondia/constants/AppTheme.dart';

/// 统一 AppBar：透明/白底、iOS 风格返回按钮
class FondiaAppBar extends StatelessWidget implements PreferredSizeWidget {
  const FondiaAppBar({
    super.key,
    this.title,
    this.backgroundColor = Colors.transparent,
    this.centerTitle = true,
    this.actions,
    this.onBack,
    this.showBack = true,
    this.titleStyle,
  });

  final String? title;
  final Color backgroundColor;
  final bool centerTitle;
  final List<Widget>? actions;
  final VoidCallback? onBack;
  final bool showBack;
  final TextStyle? titleStyle;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      elevation: 0,
      centerTitle: centerTitle,
      leading: showBack
          ? IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: AppColors.textSecondary,
                size: 20,
              ),
              onPressed: onBack ?? () => Navigator.maybePop(context),
            )
          : null,
      title: title != null
          ? Text(
              title!,
              style: titleStyle ??
                  const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
            )
          : null,
      actions: actions,
    );
  }
}
