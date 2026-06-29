
import 'package:flutter/material.dart';
import 'package:fondia/routes/Index.dart';
import 'package:fondia/stores/TokenManager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await tokenManager.init();
  runApp(getRootWidget());
}
