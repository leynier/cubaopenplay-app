import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:cubaopenplay/src/utils/app_theme.dart';
import 'package:cubaopenplay/src/utils/data_manager.dart';
import 'package:flutter/cupertino.dart';
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
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 4,
                    child: Container(
                      margin: EdgeInsets.fromLTRB(40, 15, 25, 10),
                      child: Text(
                        'Claro',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: ThemeSwitcher(
                      builder: (context) {
                        return RadioListTile(
                          value: AppThemeType.light,
                          groupValue: DataManager.appTheme,
                          activeColor: Theme.of(context).accentColor,
                          onChanged: (value) {
                            DataManager.appTheme = value;
                            ThemeSwitcher.of(context).changeTheme(
                              theme: DataManager.appTheme.theme,
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 4,
                    child: Container(
                      margin: EdgeInsets.fromLTRB(40, 15, 25, 10),
                      child: Text(
                        'Oscuro',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: ThemeSwitcher(
                      builder: (context) {
                        return RadioListTile(
                          value: AppThemeType.dark,
                          groupValue: DataManager.appTheme,
                          activeColor: Theme.of(context).accentColor,
                          onChanged: (value) {
                            DataManager.appTheme = value;
                            ThemeSwitcher.of(context).changeTheme(
                              theme: DataManager.appTheme.theme,
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
              Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
