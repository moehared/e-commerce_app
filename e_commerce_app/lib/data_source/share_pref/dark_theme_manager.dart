import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DarkThemePreference {
  static const THEME_MODE = "THEME_MODE";
  // DarkThemePreference? _darkThemePreference;
  DarkThemePreference._init();

  static final DarkThemePreference _instance = DarkThemePreference._init();
  static DarkThemePreference get instance => _instance;

  Future<void> saveTheme(String themeMode) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(THEME_MODE, themeMode);
  }

  Future<ThemeMode> getTheme() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey(THEME_MODE)) {
      return ThemeMode.system;
    }
    final theme = prefs.getString(THEME_MODE) ?? "";
    return theme.contains('ThemeMode.dark') ? ThemeMode.dark : ThemeMode.light;
  }

  Future<void> delete() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(THEME_MODE);
  }
}
