import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class LanguagesProvider extends ChangeNotifier {
  String _currentLanguage = "en";
  static const String _languageKey = 'language';

  LanguagesProvider() {
    _loadLanguageFromPrefs();
  }

  String get currentLanguage => _currentLanguage;

  Future<void> _loadLanguageFromPrefs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _currentLanguage = prefs.getString(_languageKey) ?? "en";
    notifyListeners();
  }

  Future<void> _saveLanguageToPrefs(String languageCode) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, languageCode);
  }

  Future<void> selectArabicLanguage() async {
    _currentLanguage = "ar";
    await _saveLanguageToPrefs("ar");
    notifyListeners();
  }

  Future<void> selectEnglishLanguage() async {
    _currentLanguage = "en";
    await _saveLanguageToPrefs("en");
    notifyListeners();
  }
}