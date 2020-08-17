import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:cubaopenplay/src/utils/utils.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ThemeSwitchingArea(
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text('Configuraciones'),
            centerTitle: true,
          ),
          body: ListView(
            children: <Widget>[
              Container(
                margin: EdgeInsets.fromLTRB(25, 20, 25, 10),
                child: Text(
                  'Tema Visual',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              ThemeSwitcher(
                builder: (context) {
                  return ListTile(
                    title: Container(
                      margin: EdgeInsets.only(left: 30),
                      child: Text(
                        'Claro',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    trailing: Radio(
                      value: AppThemeType.light,
                      groupValue: DataManager.appTheme,
                      onChanged: (value) {
                        DataManager.appTheme = value;
                        ThemeSwitcher.of(context).changeTheme(
                          theme: DataManager.appTheme.theme,
                        );
                      },
                    ),
                    onTap: () {
                      DataManager.appTheme = AppThemeType.light;
                      ThemeSwitcher.of(context).changeTheme(
                        theme: DataManager.appTheme.theme,
                      );
                    },
                  );
                },
              ),
              ThemeSwitcher(
                builder: (context) {
                  return ListTile(
                    title: Container(
                      margin: EdgeInsets.only(left: 30),
                      child: Text(
                        'Oscuro',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    trailing: Radio(
                      value: AppThemeType.dark,
                      groupValue: DataManager.appTheme,
                      onChanged: (value) {
                        DataManager.appTheme = value;
                        ThemeSwitcher.of(context).changeTheme(
                          theme: DataManager.appTheme.theme,
                        );
                      },
                    ),
                    onTap: () {
                      DataManager.appTheme = AppThemeType.dark;
                      ThemeSwitcher.of(context).changeTheme(
                        theme: DataManager.appTheme.theme,
                      );
                    },
                  );
                },
              ),
              Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
