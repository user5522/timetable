import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:timetable/features/timetable/widgets/grid_view/grid.dart';
import 'package:timetable/features/timetable/widgets/grid_view/grid_view_overlapping_subjects_builder.dart';
import 'package:timetable/shared/widgets/time_column.dart';
import 'package:timetable/core/constants/custom_times.dart';
import 'package:timetable/core/constants/grid_properties.dart';
import 'package:timetable/core/utils/overlapping_subjects.dart';
import 'package:timetable/core/constants/rotation_weeks.dart';
import 'package:timetable/core/db/database.dart';
import 'package:timetable/core/utils/timetables.dart';
import 'package:timetable/features/subjects/providers/overlapping_subjects.dart';
import 'package:timetable/features/timetable/widgets/grid_view/grid_view_subject_builder.dart';
import 'package:timetable/features/timetable/widgets/grid_view/grid_view_subject_container_builder.dart';
import 'package:timetable/features/timetable/widgets/grid_view/tile.dart';
import 'package:timetable/core/utils/rotation_weeks.dart';
import 'package:timetable/features/settings/providers/settings.dart';
import 'package:timetable/features/timetable/providers/timetables.dart';

/// Timetable view that shows All the days' subjects in a grid form.
class TimetableGridView extends HookConsumerWidget {
  final ValueNotifier<RotationWeeks> rotationWeek;
  final List<Subject> subject;
  final ValueNotifier<Timetable> currentTimetable;

  const TimetableGridView({
    super.key,
    required this.rotationWeek,
    required this.subject,
    required this.currentTimetable,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool compactMode = ref.watch(settingsProvider).compactMode;
    final bool multipleTimetables =
        ref.watch(settingsProvider).multipleTimetables;
    final bool twentyFourHoursMode =
        ref.watch(settingsProvider).twentyFourHours;
    final List<Timetable> timetables = ref.watch(timetableProvider);

    final TimeOfDay chosenCustomStartTime =
        ref.watch(settingsProvider).customStartTime;
    final TimeOfDay chosenCustomEndTime =
        ref.watch(settingsProvider).customEndTime;

    final TimeOfDay customStartTime =
        getCustomStartTime(chosenCustomStartTime, ref);
    final TimeOfDay customEndTime = getCustomEndTime(chosenCustomEndTime, ref);

    final List<Subject> subjects = getFilteredByTimetablesSubjects(
      currentTimetable,
      timetables,
      multipleTimetables,
      getFilteredByRotationWeeksSubjects(
        rotationWeek,
        subject,
      ),
    ).where(
      (e) {
        if (twentyFourHoursMode) return true;

        return e.endTime.hour <= customEndTime.hour &&
            e.startTime.hour >= customStartTime.hour;
      },
    ).toList();

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

  /// generates the grid
  List<List<Tile?>> generate(
    List<Subject> subjects,
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

    overlappingSubjects.addAll(findOverlappingSubjects(subjects));

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
