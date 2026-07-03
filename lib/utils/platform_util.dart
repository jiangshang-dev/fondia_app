import 'package:flutter/foundation.dart';

/// 客户端平台标识（下单用）：ios / android / web
String getClientPlatform() {
  if (kIsWeb) return 'web';
  switch (defaultTargetPlatform) {
    case TargetPlatform.iOS:
      return 'ios';
    case TargetPlatform.android:
      return 'android';
    default:
      return 'web';
  }
}

/// 套餐筛选平台（后端 platformScope）：IOS / ANDROID / WEB / ALL
String getMemberPlanPlatform() {
  if (kIsWeb) return 'WEB';
  switch (defaultTargetPlatform) {
    case TargetPlatform.iOS:
      return 'IOS';
    case TargetPlatform.android:
      return 'ANDROID';
    default:
      return 'ALL';
  }
}

bool get isIOSPlatform =>
    !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS;

bool get isAndroidPlatform =>
    !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

bool get isWebPlatform => kIsWeb;
