import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:timetable/components/subject_management/subject_screen.dart';
import 'package:timetable/components/widgets/day_view_subject_builder.dart';
import 'package:timetable/constants/custom_times.dart';
import 'package:timetable/constants/days.dart';
import 'package:timetable/constants/error_emoticons.dart';
import 'package:timetable/constants/grid_properties.dart';
import 'package:timetable/constants/rotation_weeks.dart';
import 'package:timetable/helpers/rotation_weeks.dart';
import 'package:timetable/db/database.dart';
import 'package:timetable/helpers/subjects.dart';
import 'package:timetable/helpers/timetables.dart';
import 'package:timetable/provider/settings.dart';
import 'package:timetable/provider/timetables.dart';

/// Timetable view that shows each day's subjects in a single screen each.
class TimetableDayView extends HookConsumerWidget {
  final ValueNotifier<RotationWeeks> rotationWeek;
  final List<SubjectData> subject;
  final ValueNotifier<TimetableData> currentTimetable;
  final PageController controller;

  const TimetableDayView({
    super.key,
    required this.rotationWeek,
    required this.subject,
    required this.currentTimetable,
    required this.controller,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timetables = ref.watch(timetableProvider);
    final multipleTimetables = ref.watch(settingsProvider).multipleTimetables;
    final twentyFourHoursMode = ref.watch(settingsProvider).twentyFourHours;
    final chosenCustomStartTime = ref.watch(settingsProvider).customStartTime;
    final chosenCustomEndTime = ref.watch(settingsProvider).customEndTime;

    final customStartTime = getCustomStartTime(chosenCustomStartTime, ref);
    final customEndTime = getCustomEndTime(chosenCustomEndTime, ref);

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
        tooltip: "create".tr(),
        child: const Icon(Icons.add),
      ),
      body: PageView.builder(
        itemCount: columns(ref),
        pageSnapping: true,
        controller: controller,
        itemBuilder: (context, index) {
          int startDay = ((DateTime.monday + index - 1) % 7 + 1);
          final filteredSubjects = sortSubjects(
            getFilteredByTimetablesSubjects(
              currentTimetable,
              timetables,
              multipleTimetables,
              getFilteredByRotationWeeksSubjects(
                rotationWeek,
                subject,
              ),
            ),
          ).where((s) => s.day.index == index).where(
            (e) {
              if (!twentyFourHoursMode) return true;

              return e.endTime.hour <= customEndTime.hour &&
                  e.startTime.hour >= customStartTime.hour;
            },
          ).toList();

          return LayoutBuilder(
            builder: (context, constraints) => ListView(
              padding: const EdgeInsets.all(10),
              children: [
                Text(
                  days[startDay - 1],
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 20,
                  ),
                ).tr(),
                if (filteredSubjects.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(10),
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Center(
                      child: Column(
                        children: [
                          Text(
                            getRandomErrorEmoticon(),
                            style: const TextStyle(fontSize: 25),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "no_subjects_error",
                            style: TextStyle(fontSize: 18),
                          ).tr(),
                        ],
                      ),
                    ),
                  ),
                if (filteredSubjects.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: List.generate(
                          filteredSubjects.length,
                          (index) => DayViewSubjectBuilder(
                            subject: filteredSubjects[index],
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
