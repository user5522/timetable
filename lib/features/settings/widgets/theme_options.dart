import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:timetable/core/constants/theme_options.dart';
import 'package:timetable/shared/providers/themes.dart';
import 'package:timetable/core/utils/themes.dart';

/// app theme me options dropdown menu.
class ThemeOptions extends StatelessWidget {
  final ThemeNotifier theme;

  const ThemeOptions({
    super.key,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    /// The dropdown menu entries of each ThemeOption value.
    List<DropdownMenuEntry<ThemeOption>> themeEntries() {
      final themeEntries = <DropdownMenuEntry<ThemeOption>>[];

      for (final ThemeOption option in ThemeOption.values) {
        final label = getThemeLabel(option).tr();

        themeEntries.add(
          DropdownMenuEntry<ThemeOption>(value: option, label: label),
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
          onSelected: (value) => theme.changeTheme(value!),
        ),
      ],
    );
  }
}
