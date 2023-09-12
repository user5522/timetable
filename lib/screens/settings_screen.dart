import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:timetable/components/settings/theme_options.dart';
import 'package:timetable/models/settings.dart';
import 'package:timetable/provider/themes.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.read(themeModeProvider.notifier);
    final compactMode = ref.watch(settingsProvider).compactMode;
    final hideLocation = ref.watch(settingsProvider).hideLocation;
    final singleLetterDays = ref.watch(settingsProvider).singleLetterDays;
    final settings = ref.read(settingsProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              dense: true,
              title: const Text("General"),
              textColor: Theme.of(context).colorScheme.primary,
            ),
            ListTile(
              title: ThemeOptions(
                themeMode: themeMode,
              ),
              onTap: () {},
            ),
            ListTile(
              dense: true,
              title: const Text("Customize Timetable"),
              textColor: Theme.of(context).colorScheme.primary,
            ),
            SwitchListTile(
              title: const Text("Compact Mode"),
              value: compactMode,
              onChanged: (bool value) {
                settings.updateCompactMode(value);
              },
            ),
            SwitchListTile(
              title: const Text("Hide Locations"),
              value: hideLocation,
              onChanged: (bool value) {
                settings.updateHideLocation(value);
              },
            ),
            SwitchListTile(
              title: const Text("Single Letter Days"),
              value: singleLetterDays,
              onChanged: (bool value) {
                settings.updateSingleLetterDays(value);
              },
            ),
          ],
        ),
      ),
    );
  }
}