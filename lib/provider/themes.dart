import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timetable/constants/theme_options.dart';

class ThemeModeNotifier extends StateNotifier<ThemeModeOption> {
  ThemeModeNotifier() : super(ThemeModeOption.auto) {
    _loadThemeFromSharedPreferences();
  }

  void changeTheme(ThemeModeOption newThemeMode) {
    state = newThemeMode;
    _saveThemePreference(newThemeMode);
  }

  ThemeModeOption getTheme() {
    return state;
  }

  Future<void> _loadThemeFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTheme = prefs.getString('themeMode');
    if (savedTheme != null) {
      state = ThemeModeOption.values.firstWhere(
        (element) => element.toString() == savedTheme,
      );
    }
  }

  Future<void> _saveThemePreference(ThemeModeOption themeMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'themeMode',
      themeMode.toString(),
    );
  }
}

final themeModeProvider =
    StateNotifierProvider<ThemeModeNotifier, ThemeModeOption>(
  (ref) => ThemeModeNotifier(),
);
