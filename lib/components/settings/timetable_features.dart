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
                settings: const RouteSettings(
                  name: "TimetablePeriodConfigScreen",
                ),
                builder: (context) => const TimetablePeriodScreen(),
              ),
            );
          },
          title: const Text("Time Period Configuration"),
        ),
        ListTile(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                settings: const RouteSettings(
                  name: "TimetablesManagementScreen",
                ),
                builder: (context) => const TimetableManagementScreen(),
              ),
            );
          },
          title: const Text("Manage Timetables"),
        ),
        SwitchListTile(
          title: const Text("Rotation Weeks"),
          value: rotationWeeks,
          onChanged: (bool value) {
            settings.updateRotationWeeks(value);
          },
        ),
        SwitchListTile(
          title: const Text("Auto Complete Colors"),
          subtitle: const Text(
            "auto assigns colors from previously made subjects that have matching names",
          ),
          value: autoCompleteColor,
          onChanged: (bool value) {
            settings.updateAutoCompleteColor(value);
          },
        ),
      ],
    );
  }
}
