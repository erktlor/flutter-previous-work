import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wevpn/theme/theme.dart';

class ThemeChanger with ChangeNotifier {
  ThemeData _themeData = lightTheme;
  CustomThemeColors _appThemeColors;
  SharedPreferences _prefs;

  ThemeChanger()
      : _themeData = lightTheme,
        _appThemeColors = lightAppThemeColors;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    int index = _prefs.getInt('themeMode');
    Brightness brightness = Brightness.values[index];
    if (Brightness.light == brightness) {
      _themeData = lightTheme;
    } else {
      _themeData = darkTheme;
    }
    _updateAppThemeColors(_themeData);
    notifyListeners();
  }

  _updateAppThemeColors(ThemeData theme) {
    if (theme.brightness == Brightness.light) {
      _appThemeColors = lightAppThemeColors;
    } else {
      _appThemeColors = darkAppThemeColors;
    }
  }

  ThemeData getTheme() => _themeData;

  CustomThemeColors getAppThemeColors() => _appThemeColors;

  setTheme(ThemeData theme) {
    _themeData = theme;
    _updateAppThemeColors(theme);
    _prefs.setInt('themeMode', Brightness.values.indexOf(_themeData.brightness));
    notifyListeners();
  }
}
