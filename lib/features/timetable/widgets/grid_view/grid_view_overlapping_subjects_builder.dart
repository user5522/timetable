import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:non_uniform_border/non_uniform_border.dart';
import 'package:timetable/core/utils/custom_times.dart';
import 'package:timetable/core/utils/overlapping_subjects.dart';
import 'package:timetable/features/timetable/models/subject_positions.dart';
import 'package:timetable/features/timetable/widgets/grid_view/grid_view_subject_builder.dart';
import 'package:timetable/core/db/database.dart';
import 'package:timetable/features/settings/providers/settings.dart';
import 'package:timetable/shared/providers/day.dart';

/// A widget that builds overlapping subjects in the grid view.
///
/// takes a list of [Subject] and the earlier start time hour and
/// later end time hour of the overlapping subjects.
///
/// uses the [SubjectBuilder] to build each subject.
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
      child: LayoutBuilder(
        builder: (context, constraints) {
          final positions =
              calculatePositions(subjects, earlierStartTimeHour, baseHeight);

          return Stack(
            children: positions.map((pos) {
              return Positioned(
                left: pos.left * constraints.maxWidth,
                top: pos.top,
                width: pos.width * constraints.maxWidth,
                height: pos.height,
                child: Padding(
                  padding: const EdgeInsets.all(1),
                  child: SubjectBuilder(
                    subject: pos.subject,
                    isOverlapping: true,
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }

  List<SubjectPosition> calculatePositions(
      List<Subject> subjects, int baseStartHour, double baseHeight) {
    // sort subjects by start time then by duration
    final sorted = subjects.toList()
      ..sort((a, b) {
        final startComp = a.startTime.hour.compareTo(b.startTime.hour);
        if (startComp != 0) return startComp;
        return (b.endTime.hour - b.startTime.hour)
            .compareTo(a.endTime.hour - a.startTime.hour);
      });

    final positions = <SubjectPosition>[];
    final columns = <List<Subject>>[];

    for (final subject in sorted) {
      // find first column where this subject doesn't overlap with the last subject
      int columnIndex = 0;
      while (columnIndex < columns.length &&
          overlaps(columns[columnIndex].last, subject)) {
        columnIndex++;
      }

      if (columnIndex >= columns.length) {
        columns.add(<Subject>[]);
      }

      columns[columnIndex].add(subject);

      final offset = subject.startTime.hour - baseStartHour;
      final duration = subject.endTime.hour - subject.startTime.hour;

      positions.add(SubjectPosition(
        subject: subject,
        left: columnIndex / columns.length,
        top: offset * baseHeight,
        width: 1.0 / columns.length,
        height: duration * baseHeight,
        column: columnIndex,
      ));
    }

    return positions;
  }
}
