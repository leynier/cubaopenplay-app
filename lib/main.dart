import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:cubaopenplay/src/app.dart';
import 'package:cubaopenplay/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ThemeProvider(
      initTheme: AppTheme.dark,
      child: Builder(
        builder: (BuildContext context) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: Constants.appName,
            theme: ThemeProvider.of(context),
            home: App(),
            localizationsDelegates: GlobalMaterialLocalizations.delegates,
            supportedLocales: [const Locale('es')],

          );
        },
      ),
    );
  }
}
