import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:timetable/components/subject_management/subject_configs/day_config.dart';
import 'package:timetable/components/subject_management/subject_configs/rotation_week_config.dart';
import 'package:timetable/components/subject_management/subject_configs/time_config.dart';
import 'package:timetable/components/subject_management/subject_configs/timetable_config.dart';
import 'package:timetable/components/widgets/list_item_group.dart';
import 'package:timetable/constants/days.dart';
import 'package:timetable/constants/rotation_weeks.dart';
import 'package:timetable/db/database.dart';
import 'package:timetable/provider/settings.dart';
import 'package:timetable/provider/timetables.dart';

/// Day, Time, Rotation Week & Timetable configuration part of the Subject creation screen.
///
/// basically groups [DayConfig], [RotationWeekConfig], [TimeConfig] and [TimetableConfig] in a [ListItemGroup].
class TimeDayRotationWeekTimetableConfig extends ConsumerWidget {
  final ValueNotifier<TimeOfDay> startTime;
  final ValueNotifier<TimeOfDay> endTime;
  final ValueNotifier<Days> day;
  final ValueNotifier<RotationWeeks> rotationWeek;
  final ValueNotifier<TimetableData?> timetable;

  /// whether or not the current time slot ((endTime - startTime) - tbCustomStartTime) is occupied
  /// used to show the error icon when the time is not valid/unavailable
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

    return ListItemGroup(
      children: [
        ListItem(
          title: DayConfig(
            day: day,
          ),
          onTap: () {},
        ),
        if (rotationWeeks)
          ListItem(
            title: RotationWeekConfig(
              rotationWeek: rotationWeek,
            ),
            onTap: () {},
          ),
        ListItem(
          title: TimeConfig(
            occupied: occupied,
            startTime: startTime,
            endTime: endTime,
          ),
          onTap: () {},
        ),
        if (multipleTimetables && timetables.length > 1)
          ListItem(
            title: TimetableConfig(
              timetable: timetable,
            ),
            onTap: () {},
          ),
      ],
    );
  }
}
