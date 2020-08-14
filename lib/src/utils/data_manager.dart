import 'dart:convert';

import 'package:apklis_api/models/apklis_model.dart';
import 'package:cubaopenplay/src/models/models.dart';
import 'package:cubaopenplay/src/utils/app_theme.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class DataManager {
  static Box hideBox;

  static Future<void> init() async {
    await Hive.initFlutter();
    hideBox = await Hive.openBox('data');
  }

  static Future<void> restart() async {
    await Hive.deleteFromDisk();
    await init();
  }

/* TEMPLATE FOR NEW DATA:

  ***** FOR NATIVE DATA *****

  static const  _name_key;
  static T get name => hideBox.get(_name_key);
  static set name(T value) => hideBox.put(_name_key,value);

  ****** FOR MODEL DATA *****

  static T _name;
  static const _name_key = 'name';

  static T get name {
    if (_name == null) _name = T.fromJson(hideBox.get(_name_key));
    return _name;
  }

  static set name(T value) {
    _name = value;
    hideBox.put(_name_key, value.toJson());
  }

*/

  static AppsModel _apps;
  static const _apps_key = 'apps';

  static AppsModel get appsModel {
    if (_apps == null && hideBox.containsKey(_apps_key))
      _apps = AppsModel.fromJson(
        jsonDecode(hideBox.get(_apps_key)),
      );
    return _apps;
  }

  static set appsModel(AppsModel value) {
    _apps = value;
    hideBox.put(_apps_key, jsonEncode(value.toJson()));
  }

  static AppsHashModel _hash;
  static const _hash_key = 'hash';

  static AppsHashModel get hashModel {
    if (_hash == null && hideBox.containsKey(_hash_key))
      _hash = AppsHashModel.fromJson(
        jsonDecode(hideBox.get(_hash_key)),
      );
    return _hash;
  }

  static set hashModel(AppsHashModel value) {
    _hash = value;
    hideBox.put(_hash_key, jsonEncode(value.toJson()));
  }

  static String _theme;
  static const _theme_key = 'theme';

  static AppThemeType get appTheme {
    if (_theme == null) {
      _theme = hideBox.get(_theme_key, defaultValue: AppThemeType.dark.name);
    }
    return AppTheme.getThemeType(_theme);
  }

  static set appTheme(AppThemeType value) {
    _theme = value.name;
    hideBox.put(_theme_key, value.name);
  }

  static ApklisModel _cache;
  static const _cache_key = 'cache';

  static ApklisModel get cacheModel {
    if (_cache == null && hideBox.containsKey(_cache_key))
      _cache = ApklisModel.fromJson(
        jsonDecode(hideBox.get(_cache_key)),
      );
    return _cache;
  }

  static set cacheModel(ApklisModel value) {
    _cache = value;
    hideBox.put(_cache_key, jsonEncode(value.toJson()));
  }
}
