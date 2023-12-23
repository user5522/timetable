import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:timetable/provider/settings.dart';

/// All the settings that allow for customizing the timetable.
class CustomizeTimetableOptions extends ConsumerWidget {
  const CustomizeTimetableOptions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.read(settingsProvider.notifier);
    final hideSunday = ref.watch(settingsProvider).hideSunday;
    final compactMode = ref.watch(settingsProvider).compactMode;
    final hideLocation = ref.watch(settingsProvider).hideLocation;
    final singleLetterDays = ref.watch(settingsProvider).singleLetterDays;
    final hideTransparentSubject =
        ref.watch(settingsProvider).hideTransparentSubject;

    return Column(
      children: [
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
        SwitchListTile(
          title: const Text("Hide Sunday"),
          value: hideSunday,
          onChanged: (bool value) {
            settings.updateHideSunday(value);
          },
        ),
        SwitchListTile(
          title: const Text("Hide Transparent Subjects"),
          value: hideTransparentSubject,
          onChanged: (bool value) {
            settings.updateHideTransparentSubject(value);
          },
        ),
      ],
    );
  }
}
