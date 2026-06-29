import 'package:flutter/material.dart';
import 'package:fondia/constants/AppTheme.dart';

enum ProtocolCheckboxStyle { icon, checkbox, circle }

/// 用户协议与隐私政策勾选行
class ProtocolAgreementRow extends StatelessWidget {
  const ProtocolAgreementRow({
    super.key,
    required this.value,
    required this.onChanged,
    this.style = ProtocolCheckboxStyle.icon,
    this.suffixText,
    this.center = false,
    this.fontSize = 12,
  });

  final bool value;
  final ValueChanged<bool> onChanged;
  final ProtocolCheckboxStyle style;
  final String? suffixText;
  final bool center;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    final content = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: center ? MainAxisAlignment.center : MainAxisAlignment.start,
      mainAxisSize: center ? MainAxisSize.max : MainAxisSize.min,
      children: [
        _buildCheckbox(),
        const SizedBox(width: 6),
        Flexible(child: _buildText()),
      ],
    );
    return content;
  }

  Widget _buildCheckbox() {
    switch (style) {
      case ProtocolCheckboxStyle.checkbox:
        return SizedBox(
          width: 24,
          height: 24,
          child: Checkbox(
            value: value,
            activeColor: AppColors.primary,
            shape: const CircleBorder(),
            onChanged: (v) => onChanged(v ?? false),
          ),
        );
      case ProtocolCheckboxStyle.circle:
        return GestureDetector(
          onTap: () => onChanged(!value),
          child: Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: value ? AppColors.primaryAlt : Colors.grey.shade300,
                width: 1.5,
              ),
              color: value ? AppColors.primaryAlt : Colors.transparent,
            ),
            child: value
                ? const Icon(Icons.check, size: 10, color: Colors.white)
                : null,
          ),
        );
      case ProtocolCheckboxStyle.icon:
        return GestureDetector(
          onTap: () => onChanged(!value),
          child: Icon(
            value ? Icons.check_circle : Icons.radio_button_unchecked,
            size: 18,
            color: value ? AppColors.primary : AppColors.textDisabled,
          ),
        );
    }
  }

  Widget _buildText() {
    final linkStyle = TextStyle(color: AppColors.primary, fontSize: fontSize);
    final baseStyle = TextStyle(color: AppColors.textHint, fontSize: fontSize);

    if (style == ProtocolCheckboxStyle.checkbox && suffixText != null) {
      return Text.rich(
        TextSpan(
          text: '我已阅读并同意',
          style: baseStyle.copyWith(height: 1.3),
          children: [
            TextSpan(text: '《用户服务协议》', style: linkStyle),
            const TextSpan(text: '与'),
            TextSpan(text: '《隐私政策》', style: linkStyle),
            TextSpan(text: suffixText),
          ],
        ),
      );
    }

    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text('我已阅读并同意 ', style: baseStyle),
        GestureDetector(
          onTap: () {},
          child: Text('《用户协议》', style: linkStyle),
        ),
        Text(' 和 ', style: baseStyle),
        GestureDetector(
          onTap: () {},
          child: Text('《隐私政策》', style: linkStyle),
        ),
        if (suffixText != null) Text(suffixText!, style: baseStyle),
      ],
    );
  }
}
