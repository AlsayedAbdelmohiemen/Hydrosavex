import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  SettingsProvider() {
    _loadThemeFromPreferences();
  }

  void enableDarkTheme() async {
    _themeMode = ThemeMode.dark;
    notifyListeners();
    _saveThemeToPreferences(true);
  }

  void enableLightTheme() async {
    _themeMode = ThemeMode.light;
    notifyListeners();
    _saveThemeToPreferences(false);
  }

  bool isDark() {
    return _themeMode == ThemeMode.dark;
  }



  // Save theme to SharedPreferences
  Future<void> _saveThemeToPreferences(bool isDark) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkTheme', isDark);
  }

  // Load theme from SharedPreferences
  Future<void> _loadThemeFromPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isDark = prefs.getBool('isDarkTheme');
    if (isDark != null) {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
      notifyListeners();
    }
  }
}
