import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:timetable/components/settings/screens/timetable_management_screen.dart';
import 'package:timetable/provider/settings.dart';
import 'package:timetable/components/settings/screens/timetable_period_screen.dart';

/// All the settings for changing some timetable features.
class TimetableFeaturesOptions extends ConsumerWidget {
  const TimetableFeaturesOptions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.read(settingsProvider.notifier);
    final rotationWeeks = ref.watch(settingsProvider).rotationWeeks;
    final autoCompleteColor = ref.watch(settingsProvider).autoCompleteColor;

    return Column(
      children: [
        ListTile(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const TimetablePeriodScreen(),
              ),
            );
          },
          title: const Text("timetable_period_config").tr(),
        ),
        ListTile(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const TimetableManagementScreen(),
              ),
            );
          },
          title: const Text("manage_timetables").tr(),
        ),
        SwitchListTile(
          title: const Text("rotation_week").plural(2),
          value: rotationWeeks,
          onChanged: (bool value) {
            settings.updateRotationWeeks(value);
          },
        ),
        SwitchListTile(
          title: const Text("auto_complete_colors").tr(),
          subtitle: const Text("auto_complete_colors_description").tr(),
          value: autoCompleteColor,
          onChanged: (bool value) {
            settings.updateAutoCompleteColor(value);
          },
        ),
      ],
    );
  }
}
