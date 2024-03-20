import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:timetable/constants/theme_options.dart';
import 'package:timetable/provider/themes.dart';

/// app theme mode options drop-down menu.
class ThemeOptions extends StatelessWidget {
  final ThemeModeNotifier themeMode;

  const ThemeOptions({
    super.key,
    required this.themeMode,
  });

  String getThemeModeLabel(ThemeModeOption themeMode) {
    switch (themeMode) {
      case ThemeModeOption.dark:
        return 'dark'.tr();
      case ThemeModeOption.auto:
        return 'system'.tr();
      case ThemeModeOption.light:
        return 'light'.tr();
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
        const Text('theme_mode').tr(),
        const Spacer(),
        DropdownMenu<ThemeModeOption>(
          width: 130,
          dropdownMenuEntries: themeEntries(),
          label: const Text("theme").tr(),
          initialSelection: themeMode.getTheme(),
          onSelected: (value) {
            themeMode.changeTheme(value!);
          },
        ),
      ],
    );
  }
}
