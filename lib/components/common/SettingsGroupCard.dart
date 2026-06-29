import 'package:flutter/material.dart';

/// 设置页白底圆角卡片容器
class SettingsGroupCard extends StatelessWidget {
  const SettingsGroupCard({
    super.key,
    required this.children,
    this.borderRadius = 12,
  });

  final List<Widget> children;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Column(children: children),
    );
  }
}
