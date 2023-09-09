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
            SwitchListTile(
              title: const Text("Compact Mode"),
              value: compactMode,
              onChanged: (bool value) {
                settings.updateCompactMode(value);
              },
            ),
          ],
        ),
      ),
    );
  }
}
