
import 'package:flutter/material.dart';
import 'package:fondia/app.dart';
import 'package:fondia/stores/LocaleManager.dart';
import 'package:fondia/stores/TokenManager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Future.wait([
    tokenManager.init(),
    localeManager.init(),
  ]);
  runApp(const FondiaApp());
}
