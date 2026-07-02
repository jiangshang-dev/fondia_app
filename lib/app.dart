import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:fondia/l10n/app_localizations.dart';
import 'package:fondia/pages/Login/index.dart';
import 'package:fondia/pages/Main/index.dart';
import 'package:fondia/stores/LocaleManager.dart';

class FondiaApp extends StatefulWidget {
  const FondiaApp({super.key});

  @override
  State<FondiaApp> createState() => _FondiaAppState();
}

class _FondiaAppState extends State<FondiaApp> {
  @override
  void initState() {
    super.initState();
    localeManager.addListener(_onLocaleChanged);
  }

  @override
  void dispose() {
    localeManager.removeListener(_onLocaleChanged);
    super.dispose();
  }

  void _onLocaleChanged() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: localeManager.locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      localeResolutionCallback: (locale, supported) {
        if (locale == null) return localeManager.locale;
        for (final s in supported) {
          if (s.languageCode == locale.languageCode && s.countryCode == locale.countryCode) {
            return s;
          }
        }
        for (final s in supported) {
          if (s.languageCode == locale.languageCode) return s;
        }
        return localeManager.locale;
      },
      initialRoute: '/',
      routes: {
        '/': (_) => const MainPage(),
        '/login': (_) => const LoginPage(),
      },
    );
  }
}
