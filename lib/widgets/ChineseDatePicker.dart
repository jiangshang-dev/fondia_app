import 'package:flutter/material.dart';

class ChineseDatePicker {
  static Future<DateTime?> show(
    BuildContext context, {
    required DateTime initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
  }) {
    final start = firstDate ?? DateTime(1950);
    final end = lastDate ?? DateTime.now();

    return showDatePicker(
      context: context,
      locale: const Locale('zh', 'CN'),
      initialDate: initialDate.isBefore(start)
          ? start
          : (initialDate.isAfter(end) ? end : initialDate),
      firstDate: start,
      lastDate: end,
      helpText: '选择生日',
      cancelText: '取消',
      confirmText: '确定',
      fieldLabelText: '生日日期',
      fieldHintText: '年/月/日',
      errorFormatText: '日期格式无效',
      errorInvalidText: '日期超出范围',
      builder: (ctx, child) {
        return Theme(
          data: Theme.of(ctx).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xffff7f32),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black87,
            ),
            dialogTheme: DialogThemeData(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              elevation: 8,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xffff7f32),
                textStyle: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            datePickerTheme: DatePickerThemeData(
              backgroundColor: Colors.white,
              headerBackgroundColor: const Color(0xffff7f32),
              headerForegroundColor: Colors.white,
              dayStyle: const TextStyle(fontSize: 14),
              yearStyle: const TextStyle(fontSize: 14),
              weekdayStyle: TextStyle(color: Colors.grey[600], fontSize: 13),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              dayForegroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) return Colors.white;
                return Colors.black87;
              }),
              dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return const Color(0xffff7f32);
                }
                return null;
              }),
              todayForegroundColor: WidgetStateProperty.all(const Color(0xffff7f32)),
              todayBackgroundColor: WidgetStateProperty.all(
                const Color(0xffff7f32).withOpacity(0.12),
              ),
            ),
          ),
          child: child!,
        );
      },
    );
  }
}
