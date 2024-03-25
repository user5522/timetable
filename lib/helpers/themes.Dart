import 'package:timetable/constants/theme_options.dart';

/// for each value of the enum it will give a corresponding label.
String getThemeLabel(ThemeOption theme) {
  switch (theme) {
    case ThemeOption.dark:
      return 'dark';
    case ThemeOption.auto:
      return 'system';
    case ThemeOption.light:
      return 'light';
  }
}