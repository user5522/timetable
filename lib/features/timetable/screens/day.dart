import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:timetable/features/subjects/screens/subject_screen.dart';
import 'package:timetable/features/timetable/widgets/day_view/day_view_subject_builder.dart';
import 'package:timetable/core/constants/custom_times.dart';
import 'package:timetable/core/constants/days.dart';
import 'package:timetable/core/constants/error_emoticons.dart';
import 'package:timetable/core/constants/rotation_weeks.dart';
import 'package:timetable/core/utils/rotation_weeks.dart';
import 'package:timetable/core/db/database.dart';
import 'package:timetable/core/utils/subjects.dart';
import 'package:timetable/core/utils/timetables.dart';
import 'package:timetable/features/settings/providers/settings.dart';
import 'package:timetable/features/timetable/providers/timetables.dart';
import 'package:timetable/shared/providers/day.dart';

/// Timetable view that shows each day's subjects in a single screen each.
class TimetableDayView extends HookConsumerWidget {
  final ValueNotifier<RotationWeeks> rotationWeek;
  final List<Subject> subject;
  final ValueNotifier<Timetable> currentTimetable;
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
    final weekStartDay = ref.watch(settingsProvider).weekStartDay;
    final orderedDays = ref.watch(orderedDaysProvider);

    final customStartTime = getCustomStartTime(chosenCustomStartTime, ref);
    final customEndTime = getCustomEndTime(chosenCustomEndTime, ref);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          int day = controller.page?.toInt() ?? weekStartDay;

          Navigator.push(
            context,
            MaterialPageRoute(
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
        itemCount: orderedDays.length,
        pageSnapping: true,
        controller: controller,
        itemBuilder: (context, index) {
          int dayIndex = (weekStartDay + index) % 7;
          int startDay = dayIndex;

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
          ).where((s) => s.day.index == dayIndex).where(
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
                  Day.values[startDay].name,
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
