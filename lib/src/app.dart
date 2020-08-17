import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:cubaopenplay/src/pages/pages.dart';
import 'package:cubaopenplay/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class App extends StatelessWidget {
  final showDialogToDonate;

  const App(this.showDialogToDonate);

  @override
  Widget build(BuildContext context) {
    return ThemeProvider(
      initTheme: DataManager.appTheme.theme,
      child: Builder(
        builder: (BuildContext context) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: Constants.appName,
            theme: ThemeProvider.of(context),
            home: HomePage(showDialogToDonate),
            localizationsDelegates: GlobalMaterialLocalizations.delegates,
            supportedLocales: [const Locale('es')],
          );
        },
      ),
    );
  }
}
