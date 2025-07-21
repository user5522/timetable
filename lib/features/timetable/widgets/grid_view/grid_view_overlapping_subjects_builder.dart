import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:non_uniform_border/non_uniform_border.dart';
import 'package:timetable/core/constants/custom_times.dart';
import 'package:timetable/features/timetable/widgets/grid_view/grid_view_subject_builder.dart';
import 'package:timetable/core/db/database.dart';
import 'package:timetable/features/settings/providers/settings.dart';
import 'package:timetable/shared/providers/day.dart';

/// A widget that builds overlapping subjects in the grid view.
///
/// takes a list of [SubjectData] and the earlier start time hour and
/// later end time hour of the overlapping subjects.
///
/// uses the [GridViewSubjectBuilder] to build each subject.
class OverlappingSubjBuilder extends ConsumerWidget {
  final List<Subject> subjects;
  final int earlierStartTimeHour;
  final int laterEndTimeHour;

  const OverlappingSubjBuilder({
    super.key,
    required this.subjects,
    required this.earlierStartTimeHour,
    required this.laterEndTimeHour,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customStartTime = ref.watch(settingsProvider).customStartTime;
    final customEndTime = ref.watch(settingsProvider).customEndTime;
    final compactMode = ref.watch(settingsProvider).compactMode;
    final orderedDays = ref.watch(orderedDaysProvider);
    final weekStartDay = ref.watch(settingsProvider).weekStartDay;

    final shape = NonUniformBorder(
      // both subjects should theoretically be in the same day so it doesn't matter which one we choose
      leftWidth: subjects[0].day.index == weekStartDay ? 0 : 1,
      rightWidth: subjects[0].day.index == (orderedDays.length - 1) ? 0 : 1,
      topWidth:
          earlierStartTimeHour == getCustomStartTime(customStartTime, ref).hour
              ? 0
              : 1,
      bottomWidth:
          laterEndTimeHour == getCustomEndTime(customEndTime, ref).hour ? 0 : 1,
      strokeAlign: BorderSide.strokeAlignCenter,
      color: Colors.grey,
    );

    final totalTimeSpan = laterEndTimeHour - earlierStartTimeHour;
    final baseHeight = compactMode ? 125.0 : 100.0;
    final totalHeight = baseHeight * totalTimeSpan;

    return Container(
      decoration: ShapeDecoration(shape: shape),
      height: totalHeight,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: subjects.map((subject) {
          final offset = subject.startTime.hour - earlierStartTimeHour;
          final duration = subject.endTime.hour - subject.startTime.hour;

          return Expanded(
            child: Column(
              children: [
                if (offset > 0) SizedBox(height: offset * baseHeight),
                Padding(
                  padding: const EdgeInsets.fromLTRB(1, 2, 1, 2),
                  child: SizedBox(
                    // we subtract 4 because it's the the top + bot padding
                    // shape decoration is 1 pixel on top if the later end time hour is equal to the custom timetable end time hour
                    // and is 1 pixel on the bottom if the earlier start time hour is equal to the custom timetable start time hour
                    // so we subtract all of that if the conditions are met and everything should be perfectly aligned!
                    height: duration * baseHeight -
                        4 -
                        (laterEndTimeHour ==
                                getCustomEndTime(customEndTime, ref).hour
                            ? 0
                            : 1) -
                        (earlierStartTimeHour ==
                                getCustomStartTime(customStartTime, ref).hour
                            ? 0
                            : 1),
                    child: SubjectBuilder(
                      subject: subject,
                      isOverlapping: true,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
