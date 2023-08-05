import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  ThemeModeOption _selectedThemeMode = ThemeModeOption.auto;

  ThemeModeOption get selectedThemeMode => _selectedThemeMode;

  set selectedThemeMode(ThemeModeOption newValue) {
    _selectedThemeMode = newValue;
    saveThemeMode(newValue);
    notifyListeners();
  }

  Future<void> loadThemeMode() async {
    final ThemeModeOption themeMode = await getThemeMode();
    _selectedThemeMode = themeMode;
    notifyListeners();
  }

  Future<void> saveThemeMode(ThemeModeOption themeMode) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('theme_mode', themeMode.index);
  }

  Future<ThemeModeOption> getThemeMode() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final int? themeModeIndex = prefs.getInt('theme_mode');
    return ThemeModeOption.values[themeModeIndex ?? 0];
  }
}

enum ThemeModeOption { dark, light, auto }