import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:timetable/components/subject_management/subject_configs/colors_config.dart';
import 'package:timetable/components/subject_management/subject_configs/day_time_week_tb_config.dart';
import 'package:timetable/components/subject_management/subject_configs/label_location_config.dart';
import 'package:timetable/components/subject_management/subject_configs/note_tile.dart';
import 'package:timetable/constants/days.dart';
import 'package:timetable/constants/rotation_weeks.dart';
import 'package:timetable/db/database.dart';
import 'package:timetable/provider/overlapping_subjects.dart';
import 'package:timetable/provider/settings.dart';
import 'package:timetable/provider/subjects.dart';
import 'package:timetable/provider/timetables.dart';

/// The Subject creation/modification screen.
class SubjectScreen extends HookConsumerWidget {
  final int? rowIndex;
  final int? columnIndex;
  final SubjectData? subject;
  final ValueNotifier<TimetableData>? currentTimetable;

  const SubjectScreen({
    super.key,
    this.subject,
    this.rowIndex,
    this.columnIndex,
    this.currentTimetable,
  });

  static final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subjects = ref.watch(subjectProvider);
    final subjectNotifier = ref.watch(subjectProvider.notifier);
    final overlappingSubjects = ref.watch(overlappingSubjectsProvider);
    final autoCompleteColor = ref.watch(settingsProvider).autoCompleteColor;
    final timetables = ref.watch(timetableProvider);
    final tfHours = ref.watch(settingsProvider).twentyFourHours;
    final customStartTimeHour =
        ref.watch(settingsProvider).customStartTime.hour;

    final bool isSubjectNull = (subject == null);
    final bool isCTimetableNull = (currentTimetable == null);
    final int id = isSubjectNull ? subjects.length : subject!.id;

    final timetable = useState(
      isSubjectNull
          ? isCTimetableNull
              ? timetables
                  .where((t) => t.name == subject!.timetable)
                  .firstOrNull
              : currentTimetable!.value
          : timetables.where((t) => t.name == subject!.timetable).firstOrNull,
    );
    final startTime = useState(
      TimeOfDay(
        hour: subject?.startTime.hour ??
            (rowIndex! + (tfHours ? 0 : customStartTimeHour)),
        minute: 0,
      ),
    );
    final ValueNotifier<TimeOfDay> endTime = useState(
      TimeOfDay(
        hour: subject?.endTime.hour ??
            (rowIndex! + (tfHours ? 0 : customStartTimeHour) + 1),
        minute: 0,
      ),
    );

    final label = useState(subject?.label ?? "");
    final location = useState(subject?.location ?? "");
    final note = useState(subject?.note ?? "");
    final ValueNotifier<Days> day =
        useState(Days.values[subject?.day.index ?? columnIndex!]);
    final color = useState(subject?.color ?? Colors.black);
    final rotationWeek = useState(subject?.rotationWeek ?? RotationWeeks.none);

    // I DONT KNOW WHY I AM USING [SubjectData] I SHOULD BE USING [SubjectCompanion]
    final SubjectData newSubject = SubjectData(
      id: id,
      label: label.value,
      location: location.value,
      color: color.value,
      startTime: startTime.value,
      endTime: endTime.value,
      day: day.value,
      rotationWeek: rotationWeek.value,
      note: note.value,
      timetable: timetable.value!.name,
    );

    final subjectsInSameDay = subjects
        .where(
          (e) => e.day == day.value,
        )
        .toList();

// all the upcomming variables are checks to
// limit the amount of overlapping subjects.
// i should really work and find a solution to that issue..

    final multipleOccupied = overlappingSubjects.any((e) {
      for (var subject in e) {
        return newSubject == subject;
      }
      return false;
    })
        ? false
        : subjectsInSameDay
                .where((s) {
                  final sHours = List.generate(
                    s.endTime.hour - s.startTime.hour,
                    (index) => index + s.startTime.hour,
                  );
                  final inputHours = List.generate(
                    endTime.value.hour - startTime.value.hour,
                    (index) => index + startTime.value.hour,
                  );

                  return sHours.any((hour) => inputHours.contains(hour));
                })
                .where((s) => s != subject)
                .where((e) => e.timetable == newSubject.timetable)
                .length >
            1;

    final isOccupied = subjectsInSameDay
        .where((e) => overlappingSubjects.any((elem) => elem.contains(e)))
        .where((e) => e.timetable == newSubject.timetable)
        .any((e) {
      final eHours = List.generate(
        e.endTime.hour - e.startTime.hour,
        (index) => index + e.startTime.hour,
      );
      final inputHours = List.generate(
        endTime.value.hour - startTime.value.hour,
        (index) => index + startTime.value.hour,
      );

      return eHours.any((hour) => inputHours.contains(hour));
    });

    final isOccupiedExceptSelf = subjectsInSameDay
        .where((e) => e != subject)
        .where((e) => !overlappingSubjects.any((elem) => elem.contains(e)))
        .where((e) => e.timetable == newSubject.timetable)
        .any((e) {
      final eHours = List.generate(
        e.endTime.hour - e.startTime.hour,
        (index) => index + e.startTime.hour,
      );
      final inputHours = List.generate(
        endTime.value.hour - startTime.value.hour,
        (index) => index + startTime.value.hour,
      );
      return eHours.any((hour) => inputHours.contains(hour));
    });

// end of checks

    return Scaffold(
      appBar: AppBar(
        actions: [
          if (!isSubjectNull)
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shadowColor: Colors.transparent,
                backgroundColor: Theme.of(context).colorScheme.error,
                foregroundColor: Theme.of(context).colorScheme.errorContainer,
              ),
              onPressed: () {
                subjectNotifier.deleteSubject(newSubject);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('subject_deleted_snackbar').tr(),
                  ),
                );
                Navigator.pop(context);
              },
              child: const Text("delete").tr(),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shadowColor: Colors.transparent,
                backgroundColor:
                    Theme.of(context).colorScheme.onPrimaryContainer,
                foregroundColor:
                    Theme.of(context).colorScheme.secondaryContainer,
              ),
              onPressed: () {
                if (!formKey.currentState!.validate()) {
                  return;
                }
                if (isSubjectNull) {
                  if (isOccupied && multipleOccupied) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('time_slots_occupied_error').tr(),
                      ),
                    );
                    return;
                  }
                  subjectNotifier.addSubject(newSubject.toCompanion(false));
                  Navigator.pop(context, label.value);
                }
                if (!isSubjectNull) {
                  if (isOccupiedExceptSelf && multipleOccupied) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        // I don't know how to say the error in french so I translated it :P
                        content: const Text('time_slots_occupied_error').tr(),
                      ),
                    );
                    return;
                  }
                  subjectNotifier.updateSubject(newSubject);
                  Navigator.pop(context, label.value);
                }
              },
              child: Text(isSubjectNull ? "create".tr() : "save".tr()),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LabelLocationConfig(
                  subjects: subjects,
                  label: label,
                  location: location,
                  color: color,
                  autoCompleteColor: autoCompleteColor,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: ColorsConfig(color: color),
                ),
                TimeDayRotationWeekTimetableConfig(
                  day: day,
                  rotationWeek: rotationWeek,
                  startTime: startTime,
                  endTime: endTime,
                  timetable: timetable,
                  occupied: isSubjectNull
                      ? (isOccupied || multipleOccupied)
                      : (isOccupiedExceptSelf || multipleOccupied),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: NotesTile(
                    note: note,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
