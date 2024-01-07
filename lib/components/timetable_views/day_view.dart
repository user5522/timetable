import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:timetable/components/subject_management/subject_screen.dart';
import 'package:timetable/components/widgets/day_view_navigation_bar.dart';
import 'package:timetable/components/widgets/day_view_subject_builder.dart';
import 'package:timetable/constants/days.dart';
import 'package:timetable/constants/grid_properties.dart';
import 'package:timetable/constants/rotation_weeks.dart';
import 'package:timetable/helpers/rotation_weeks.dart';
import 'package:timetable/db/database.dart';
import 'package:timetable/helpers/sort_subjects.dart';
import 'package:timetable/helpers/timetables.dart';
import 'package:timetable/provider/settings.dart';
import 'package:timetable/provider/timetables.dart';

/// Timetable view that shows each day's subjects in a single screen.
class TimetableDayView extends HookConsumerWidget {
  final ValueNotifier<RotationWeeks> rotationWeek;
  final List<SubjectData> subject;
  final ValueNotifier<TimetableData> currentTimetable;

  const TimetableDayView({
    super.key,
    required this.rotationWeek,
    required this.subject,
    required this.currentTimetable,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timetables = ref.watch(timetableProvider);
    final multipleTimetables = ref.watch(settingsProvider).multipleTimetables;
    PageController controller;
    controller = PageController(initialPage: DateTime.now().weekday - 1);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          int day = controller.page?.toInt() ?? 0;

          Navigator.push(
            context,
            MaterialPageRoute(
              settings: const RouteSettings(
                name: "CellScreen",
              ),
              builder: (context) => SubjectScreen(
                rowIndex: 0,
                columnIndex: day,
                currentTimetable: currentTimetable,
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          DayViewNavigationBar(
            controller: controller,
          ),
          Expanded(
            child: PageView.builder(
              itemCount: columns(ref),
              pageSnapping: true,
              controller: controller,
              itemBuilder: (context, index) {
                int startDay = ((DateTime.monday + index - 1) % 7 + 1);

                return SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          days[startDay - 1],
                          style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 20,
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: sortSubjects(
                            getFilteredByTimetablesSubjects(
                              currentTimetable,
                              timetables,
                              multipleTimetables,
                              getFilteredByRotationWeeksSubjects(
                                rotationWeek,
                                subject,
                              ),
                            ),
                          )
                              .where((s) => s.day.index == index)
                              .map(
                                (subject) => DayViewSubjectBuilder(
                                  subject: subject,
                                ),
                              )
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
