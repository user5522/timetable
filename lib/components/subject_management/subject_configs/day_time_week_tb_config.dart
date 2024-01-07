import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:timetable/components/subject_management/subject_configs/day_config.dart';
import 'package:timetable/components/subject_management/subject_configs/rotation_week_config.dart';
import 'package:timetable/components/subject_management/subject_configs/time_config.dart';
import 'package:timetable/components/subject_management/subject_configs/timetable_config.dart';
import 'package:timetable/components/widgets/list_tile_group.dart';
import 'package:timetable/constants/days.dart';
import 'package:timetable/constants/rotation_weeks.dart';
import 'package:timetable/db/database.dart';
import 'package:timetable/provider/settings.dart';
import 'package:timetable/provider/timetables.dart';

/// Day, Time & Rotation Week config part of the Subject creation screen.
class TimeDayRotationWeekTimetableConfig extends ConsumerWidget {
  final ValueNotifier<TimeOfDay> startTime;
  final ValueNotifier<TimeOfDay> endTime;
  final ValueNotifier<Days> day;
  final ValueNotifier<RotationWeeks> rotationWeek;
  final ValueNotifier<TimetableData?> timetable;
  final bool occupied;

  const TimeDayRotationWeekTimetableConfig({
    super.key,
    required this.startTime,
    required this.endTime,
    required this.day,
    required this.rotationWeek,
    required this.timetable,
    required this.occupied,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rotationWeeks = ref.watch(settingsProvider).rotationWeeks;
    final multipleTimetables = ref.watch(settingsProvider).multipleTimetables;
    final timetables = ref.watch(timetableProvider);

    return ListTileGroup(
      children: [
        ListItem(
          title: DayConfig(
            day: day,
          ),
        ),
        if (rotationWeeks)
          ListItem(
            title: RotationWeekConfig(
              rotationWeek: rotationWeek,
            ),
          ),
        ListItem(
          title: TimeConfig(
            occupied: occupied,
            startTime: startTime,
            endTime: endTime,
          ),
        ),
        if (multipleTimetables && timetables.length > 1)
          ListItem(
            title: TimetableConfig(
              timetable: timetable,
            ),
          ),
      ],
    );
  }
}
