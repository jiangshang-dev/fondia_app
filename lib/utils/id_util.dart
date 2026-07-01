/// 雪花 ID 等超长整数统一用 String，避免 JSON 数字在 Web/JS 环境精度丢失。
String asIdString(dynamic value, {String defaultValue = '0'}) {
  if (value == null) return defaultValue;
  if (value is String) return value.isEmpty ? defaultValue : value;
  if (value is int) return value.toString();
  if (value is double) {
    // 若后端仍返回 number 且已被解析为 double，只能尽量转字符串（可能已丢精度）
    return value.toStringAsFixed(0);
  }
  final text = value.toString();
  return text.isEmpty ? defaultValue : text;
}
