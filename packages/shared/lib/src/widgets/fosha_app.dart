import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../theme/fosha_theme.dart';

/// Base app wrapper enforcing:
/// - RTL
/// - Arabic-first locale (`ar_EG`)
/// - FOSHA dark theme
class FoshaApp extends StatelessWidget {
  const FoshaApp({
    super.key,
    required this.title,
    this.home,
    this.routerConfig,
    this.debugShowCheckedModeBanner = false,
  });

  final String title;
  final Widget? home;
  final RouterConfig<Object>? routerConfig;
  final bool debugShowCheckedModeBanner;

  @override
  Widget build(BuildContext context) {
    if (routerConfig != null) {
      return MaterialApp.router(
        debugShowCheckedModeBanner: debugShowCheckedModeBanner,
        title: title,
        theme: FoshaTheme.dark(),
        locale: const Locale('ar', 'EG'),
        supportedLocales: const [
          Locale('ar', 'EG'),
          Locale('en', 'US'),
        ],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        builder: (context, child) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: child ?? const SizedBox.shrink(),
          );
        },
        routerConfig: routerConfig,
      );
    }

    return MaterialApp(
      debugShowCheckedModeBanner: debugShowCheckedModeBanner,
      title: title,
      theme: FoshaTheme.dark(),
      locale: const Locale('ar', 'EG'),
      supportedLocales: const [
        Locale('ar', 'EG'),
        Locale('en', 'US'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child ?? const SizedBox.shrink(),
        );
      },
      home: home,
    );
  }
}
