import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:timetable/components/widgets/grid.dart';
import 'package:timetable/models/subjects.dart';
import 'package:timetable/components/widgets/grid_view_subject_builder.dart';
import 'package:timetable/components/widgets/subject_container_builder.dart';
import 'package:timetable/components/widgets/tile.dart';
import 'package:timetable/models/settings.dart';
import 'package:timetable/screens/timetable_screen.dart';
import 'package:timetable/utilities/grid_utils.dart';

class TimetableGridView extends HookConsumerWidget {
  const TimetableGridView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subject = ref.watch(subjectProvider);
    final compactMode = ref.watch(settingsProvider).compactMode;
    final singleLetterDays = ref.watch(settingsProvider).singleLetterDays;

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
            Column(
              children: List.generate(
                10,
                (i) => Container(
                  alignment: Alignment.topCenter,
                  height: compactMode ? 125 : 100,
                  width: 20,
                  child: Text(times24h[i + (8 - 1)]),
                ),
              ),
            ),
            Column(
              children: [
                Row(
                  children: List.generate(
                    days.length,
                    (i) => Container(
                      alignment: Alignment.bottomCenter,
                      height: 20,
                      width: compactMode
                          ? (screenWidth / columns - (30 / rows))
                          : 100,
                      child: Text(
                        singleLetterDays
                            ? days[i][0]
                            : compactMode
                                ? days[i].substring(0, 3)
                                : days[i],
                      ),
                    ),
                  ),
                ),
                Grid(
                  tileHeight: compactMode ? 125 : 100,
                  tileWidth:
                      compactMode ? (screenWidth / columns - (30 / rows)) : 100,
                  rows: rows,
                  columns: columns,
                  grid: generate(subject, columns, rows),
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
