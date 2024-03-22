import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:timetable/components/widgets/grid.dart';
import 'package:timetable/components/widgets/grid_view_overlapping_subjects_builder.dart';
import 'package:timetable/components/widgets/time_column.dart';
import 'package:timetable/constants/custom_times.dart';
import 'package:timetable/constants/grid_properties.dart';
import 'package:timetable/helpers/overlapping_subjects.dart';
import 'package:timetable/constants/rotation_weeks.dart';
import 'package:timetable/db/database.dart';
import 'package:timetable/helpers/timetables.dart';
import 'package:timetable/provider/overlapping_subjects.dart';
import 'package:timetable/components/widgets/grid_view_subject_builder.dart';
import 'package:timetable/components/widgets/grid_view_subject_container_builder.dart';
import 'package:timetable/components/widgets/tile.dart';
import 'package:timetable/helpers/rotation_weeks.dart';
import 'package:timetable/provider/settings.dart';
import 'package:timetable/provider/timetables.dart';

/// Timetable view that shows All the days' subjects in a grid form.
class TimetableGridView extends HookConsumerWidget {
  final ValueNotifier<RotationWeeks> rotationWeek;
  final List<SubjectData> subject;
  final ValueNotifier<TimetableData> currentTimetable;

  const TimetableGridView({
    super.key,
    required this.rotationWeek,
    required this.subject,
    required this.currentTimetable,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final compactMode = ref.watch(settingsProvider).compactMode;
    final customStartTime = ref.watch(settingsProvider).customStartTime;
    final customEndTime = ref.watch(settingsProvider).customEndTime;
    final timetables = ref.watch(timetableProvider);
    final multipleTimetables = ref.watch(settingsProvider).multipleTimetables;
    final subjects = getFilteredByTimetablesSubjects(
      currentTimetable,
      timetables,
      multipleTimetables,
      getFilteredByRotationWeeksSubjects(
        rotationWeek,
        subject,
      ),
    )
        .where(
          (e) =>
              e.endTime.hour <= getCustomEndTime(customEndTime, ref).hour &&
              e.startTime.hour >= getCustomStartTime(customStartTime, ref).hour,
        )
        .toList();

    Future.delayed(
      Duration.zero,
      () async {
        final overlappingSubjectsNotifier =
            ref.read(overlappingSubjectsProvider.notifier);

        overlappingSubjectsNotifier
            .addInBulk(findOverlappingSubjects(subjects));
      },
    );

    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    final double tileHeight = compactMode ? 125 : 100;
    final double tileWidth = compactMode
        ? (screenWidth / columns(ref) - ((timeColumnWidth + 10) / 10))
        : isPortrait
            ? 100
            : (screenWidth / columns(ref) - ((timeColumnWidth + 10) / 10));

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: compactMode
            ? const NeverScrollableScrollPhysics()
            : const ScrollPhysics(),
        child: Row(
          children: [
            const TimeColumn(),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Grid(
                    tileHeight: tileHeight,
                    tileWidth: tileWidth,
                    rows: rows(ref),
                    columns: columns(ref),
                    grid: generate(
                      subjects,
                      columns(ref),
                      rows(ref),
                      ref,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<List<Tile?>> generate(
    List<SubjectData> subjects,
    int totalDays,
    int totalHours,
    WidgetRef ref,
  ) {
    final overlappingSubjects = ref.watch(overlappingSubjectsProvider);
    final timetables = ref.watch(timetableProvider);
    final customStartTime = ref.watch(settingsProvider).customStartTime;

    // subjects' containers
    final List<List<Tile?>> grid = List.generate(
      totalDays,
      (columnIndex) => List.generate(
        totalHours,
        (rowIndex) => Tile(
          child: SubjectContainerBuilder(
            rowIndex: rowIndex,
            columnIndex: columnIndex,
            currentTimetable: currentTimetable,
          ),
        ),
      ),
    );

    // overlapping subjects
    if (overlappingSubjects.isNotEmpty &&
        overlappingSubjects.any(
          (e) => e.length == 2,
        )) {
      filterOverlappingSubjectsByRotationWeeks(
        overlappingSubjects,
        rotationWeek,
      );
      filterOverlappingSubjectsByTimetable(
        overlappingSubjects,
        currentTimetable,
        timetables,
      );
    }

    for (final subjects in overlappingSubjects) {
      var day = subjects[0].day.index;
      var earlierStartTimeHour = getEarliestSubject(subjects).startTime.hour;
      var laterEndTimeHour = getLatestSubject(subjects).endTime.hour;

      var startTime = getEarliestSubject(subjects).startTime.hour -
          getCustomStartTime(customStartTime, ref).hour;
      var endTime = getLatestSubject(subjects).endTime.hour -
          getCustomStartTime(customStartTime, ref).hour;
      var column = grid[day];

      column.replaceRange(
        startTime,
        endTime,
        List.generate(endTime - startTime, (_) => null),
      );

      column[startTime] = Tile(
        height: endTime - startTime,
        child: OverlappingSubjBuilder(
          subjects: subjects,
          earlierStartTimeHour: earlierStartTimeHour,
          laterEndTimeHour: laterEndTimeHour,
        ),
      );
    }

    // normal subjects
    for (final subject in filterOverlappingSubjects(
      subjects,
      overlappingSubjects,
    )) {
      var day = subject.day.index;
      var start = subject.startTime.hour -
          getCustomStartTime(customStartTime, ref).hour;
      var end =
          subject.endTime.hour - getCustomStartTime(customStartTime, ref).hour;

      var column = grid[day];

      column.replaceRange(
        start,
        end,
        List.generate(end - start, (_) => null),
      );

      column[start] = Tile(
        height: end - start,
        child: SubjectBuilder(subject: subject),
      );
    }

    return grid;
  }
}
