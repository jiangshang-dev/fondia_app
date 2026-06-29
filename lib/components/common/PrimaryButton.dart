import 'package:flutter/material.dart';
import 'package:fondia/constants/AppTheme.dart';

/// 主色 CTA 按钮
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.height = 56,
    this.borderRadius = AppRadius.pill,
    this.fontSize = 18,
    this.letterSpacing = 2,
    this.elevation = 2,
  });

  final String text;
  final VoidCallback? onPressed;
  final double height;
  final double borderRadius;
  final double fontSize;
  final double letterSpacing;
  final double elevation;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: elevation,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            letterSpacing: letterSpacing,
          ),
        ),
      ),
    );
  }
}
