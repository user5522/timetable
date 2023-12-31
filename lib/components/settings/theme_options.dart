import 'package:flutter/material.dart';
import 'package:timetable/constants/theme_options.dart';
import 'package:timetable/provider/themes.dart';

/// application's theme mode options drop-down menu.
class ThemeOptions extends StatelessWidget {
  const ThemeOptions({
    super.key,
    required this.themeMode,
  });

  final ThemeModeNotifier themeMode;

  String getThemeModeLabel(ThemeModeOption themeMode) {
    switch (themeMode) {
      case ThemeModeOption.dark:
        return 'Dark';
      case ThemeModeOption.auto:
        return 'System';
      case ThemeModeOption.light:
        return 'Light';
    }
  }

  @override
  Widget build(BuildContext context) {
    List<DropdownMenuEntry<ThemeModeOption>> themeEntries() {
      final themeEntries = <DropdownMenuEntry<ThemeModeOption>>[];

      for (final ThemeModeOption option in ThemeModeOption.values) {
        themeEntries.add(
          DropdownMenuEntry<ThemeModeOption>(
            value: option,
            label: getThemeModeLabel(option),
          ),
        );
      }
      return themeEntries.toList();
    }

    return Row(
      children: [
        const Text('Theme Mode'),
        const Spacer(),
        DropdownMenu<ThemeModeOption>(
          width: 120,
          dropdownMenuEntries: themeEntries(),
          label: const Text("Theme"),
          initialSelection: themeMode.getTheme(),
          onSelected: (value) {
            themeMode.changeTheme(value!);
          },
        ),
      ],
    );
  }
}
