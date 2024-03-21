import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timetable/constants/theme_options.dart';

/// Themes' [StateNotifier].
class ThemeNotifier extends StateNotifier<ThemeOption> {
  ThemeNotifier() : super(ThemeOption.auto) {
    loadTheme();
  }

  void changeTheme(ThemeOption newTheme) {
    state = newTheme;
    saveTheme(newTheme);
  }

  ThemeOption getTheme() {
    return state;
  }

  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTheme = prefs.getString('theme');
    if (savedTheme == null) return;

    state = ThemeOption.values.firstWhere(
      (element) => element.toString() == savedTheme,
    );
  }

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
