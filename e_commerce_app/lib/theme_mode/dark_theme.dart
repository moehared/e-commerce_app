import 'dart:convert';

import 'package:e_commerce_app/main.dart';
import 'package:flutter/material.dart';

class MyTheme with ChangeNotifier {
  static bool _isDark = false;
  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode currenTheme() {
    if (_themeMode == ThemeMode.system && !_isDark) return ThemeMode.system;
    return _isDark ? _themeMode = ThemeMode.dark : _themeMode = ThemeMode.light;
  }

  // set setTheme(ThemeMode themeMode) {
  //   _themeMode = themeMode;
  //   notifyListeners();
  // }

  void setTheme(ThemeMode themeMode) {
    _themeMode = themeMode;
    print('current theme is inside get theme is  $_themeMode\n');
    notifyListeners();
  }

  ThemeMode get theme => _themeMode;

  void switchTheme(bool isOn) {
    // toggle theme mode
    _isDark = isOn;
    // we need to save theme mode
    final themeData = json.encode(currenTheme().toString());
    setTheme(currenTheme());
    print('Toggle theme mode to $_themeMode\n');
    darkThemePref.saveTheme(themeData);
    notifyListeners();
  }

  Future<ThemeMode> getTheme() async {
    final currentTheme = await darkThemePref.getTheme();
    return currentTheme;
    // setTheme(currentTheme);

    // notifyListeners();
  }

  bool get isDark => _isDark;

  static final darkTheme = ThemeData(
    primarySwatch: Colors.grey,
    primaryColor: Colors.black,
    scaffoldBackgroundColor: Colors.grey.shade900,
    colorScheme: ColorScheme.dark(),
    accentColor: Colors.white,
    accentIconTheme: IconThemeData(color: Colors.black),
    iconTheme: IconThemeData(color: Colors.white),
    dividerColor: Colors.white,
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    buttonColor: Colors.red,
  );

  static final lightTheme = ThemeData(
    scaffoldBackgroundColor: Colors.white,
    primaryColor: Colors.white,
    accentColor: Colors.black,
    colorScheme: ColorScheme.light(),
    iconTheme: IconThemeData(color: Colors.black, opacity: 1),
    textTheme: TextTheme(
      headline4: TextStyle(fontFamily: 'LIME'),
    ),
    accentIconTheme: IconThemeData(color: Colors.white),
    dividerColor: Colors.black,
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,

    buttonColor: Colors.red,
    // iconTheme: IconThemeData(color: Colors.deepOrange.shade900, opacity: 0.8),
  );
}
