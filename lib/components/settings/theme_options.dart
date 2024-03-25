import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:timetable/constants/theme_options.dart';
import 'package:timetable/provider/themes.dart';

/// app theme me options dropdown menu.
class ThemeOptions extends StatelessWidget {
  final ThemeNotifier theme;

  const ThemeOptions({
    super.key,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
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

    List<DropdownMenuEntry<ThemeOption>> themeEntries() {
      final themeEntries = <DropdownMenuEntry<ThemeOption>>[];

      for (final ThemeOption option in ThemeOption.values) {
        themeEntries.add(
          DropdownMenuEntry<ThemeOption>(
            value: option,
            label: getThemeLabel(option).tr(),
          ),
        );
      }
      return themeEntries.toList();
    }

    return Row(
      children: [
        const Text('theme_mode').tr(),
        const Spacer(),
        DropdownMenu<ThemeOption>(
          width: 130,
          dropdownMenuEntries: themeEntries(),
          label: const Text("theme").tr(),
          initialSelection: theme.getTheme(),
          onSelected: (value) {
            theme.changeTheme(value!);
          },
        ),
      ],
    );
  }
}
