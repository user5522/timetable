import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timetable/core/constants/theme_options.dart';

/// Theme state management
class ThemeNotifier extends StateNotifier<ThemeOption> {
  ThemeNotifier() : super(ThemeOption.auto) {
    loadTheme();
  }

  /// changes the current theme to a provided one
  void changeTheme(ThemeOption newTheme) {
    state = newTheme;
    saveTheme(newTheme);
  }

  /// returns the current theme from state
  ThemeOption getTheme() {
    return state;
  }

  /// loads current theme from shared preferences
  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTheme = prefs.getString('theme');
    if (savedTheme == null) return;

    state = ThemeOption.values.firstWhere(
      (element) => element.toString() == savedTheme,
    );
  }

  /// saves current theme to shared preferences
  Future<void> saveTheme(ThemeOption theme) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'theme',
      theme.toString(),
    );
  }
}

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeOption>(
  (ref) => ThemeNotifier(),
);
