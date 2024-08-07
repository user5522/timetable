import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:timetable/components/settings/screens/timetable_management.dart';
import 'package:timetable/provider/settings.dart';
import 'package:timetable/components/settings/screens/timetable_period.dart';

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
          leading: const Icon(
            Icons.schedule_outlined,
            size: 20,
          ),
          horizontalTitleGap: 8,
          title: const Text("timetable_period_config").tr(),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const TimetablePeriodScreen(),
              ),
            );
          },
        ),
        ListTile(
          leading: const Icon(
            Icons.table_view_outlined,
            size: 20,
          ),
          horizontalTitleGap: 8,
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
          secondary: const Icon(
            Icons.rotate_90_degrees_ccw_outlined,
            size: 20,
          ),
          visualDensity: const VisualDensity(horizontal: -4),
          title: const Text("rotation_week").plural(2),
          value: rotationWeeks,
          onChanged: (bool value) {
            settings.updateRotationWeeks(value);
          },
        ),
        SwitchListTile(
          secondary: const Icon(
            Icons.format_color_fill_outlined,
            size: 20,
          ),
          visualDensity: const VisualDensity(horizontal: -4),
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
