import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:timetable/components/widgets/days_row.dart';
import 'package:timetable/components/widgets/grid.dart';
import 'package:timetable/components/widgets/time_column.dart';
import 'package:timetable/constants/grid_properties.dart';
import 'package:timetable/constants/rotation_weeks.dart';
import 'package:timetable/models/subjects.dart';
import 'package:timetable/components/widgets/grid_view_subject_builder.dart';
import 'package:timetable/components/widgets/subject_container_builder.dart';
import 'package:timetable/components/widgets/tile.dart';
import 'package:timetable/models/settings.dart';

class TimetableGridView extends HookConsumerWidget {
  final ValueNotifier<RotationWeeks> rotationWeek;

  const TimetableGridView({
    super.key,
    required this.rotationWeek,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subject = ref.watch(subjectProvider);
    final compactMode = ref.watch(settingsProvider).compactMode;

    double screenWidth = MediaQuery.of(context).size.width;

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
                const DaysRow(),
                Grid(
                  tileHeight: compactMode ? 125 : 100,
                  tileWidth: compactMode
                      ? (screenWidth / columns -
                          ((timeColumnWidth + 10) / rows))
                      : 100,
                  rows: rows,
                  columns: columns,
                  grid: generate(
                      getFilteredSubject(rotationWeek, subject), columns, rows),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<List<Tile?>> generate(
    List<Subject> subjects,
    int totalDays,
    int totalHours,
  ) {
    final List<List<Tile?>> grid = List.generate(
      totalDays,
      (ci) => List.generate(
        totalHours,
        (ri) => Tile(
          child: SubjectContainerBuilder(
            rowIndex: ri,
            columnIndex: ci,
          ),
        ),
      ),
    );

    for (final subject in subjects) {
      var day = subject.day.index;
      var start = subject.startTime.hour - 8;
      var end = subject.endTime.hour - 8;

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
