import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 应用语言管理：本地缓存，切换后全局生效
class LocaleManager extends ChangeNotifier {
  static const _storageKey = 'app_locale';

  Locale _locale = const Locale('zh', 'CN');

  Locale get locale => _locale;

  /// zh_CN | zh_TW | en_US
  String get localeCode {
    if (_locale.languageCode == 'en') return 'en_US';
    if (_locale.countryCode == 'TW') return 'zh_TW';
    return 'zh_CN';
  }

  static const supportedLocales = [
    Locale('zh', 'CN'),
    Locale('zh', 'TW'),
    Locale('en', 'US'),
  ];

  static Locale localeFromCode(String code) {
    switch (code) {
      case 'zh_TW':
        return const Locale('zh', 'TW');
      case 'en_US':
        return const Locale('en', 'US');
      default:
        return const Locale('zh', 'CN');
    }
  }

  /// 语言设置页展示名称（保持各语言原生写法）
  static const languageOptions = [
    ('zh_CN', '简体字（中国大陆地区）'),
    ('zh_TW', '正体字（中国）'),
    ('en_US', 'English'),
  ];

  String get currentLanguageLabel {
    return languageOptions
        .firstWhere((e) => e.$1 == localeCode, orElse: () => languageOptions.first)
        .$2;
  }

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_storageKey);
    if (saved != null) {
      _locale = localeFromCode(saved);
    }
  }

  Future<void> setLocaleCode(String code) async {
    final next = localeFromCode(code);
    if (_locale == next) return;
    _locale = next;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, code);
  }
}

final localeManager = LocaleManager();
