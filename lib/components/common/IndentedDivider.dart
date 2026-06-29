import 'package:flutter/material.dart';
import 'package:fondia/constants/AppTheme.dart';

/// 带左侧缩进的分割线（卡片内列表分隔）
class IndentedDivider extends StatelessWidget {
  const IndentedDivider({
    super.key,
    this.indent = 52,
    this.color = AppColors.divider,
    this.thickness = 0.5,
  });

  final double indent;
  final Color color;
  final double thickness;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: indent),
      child: Divider(height: 1, thickness: thickness, color: color),
    );
  }
}
