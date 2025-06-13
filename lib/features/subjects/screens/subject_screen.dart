import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:timetable/core/utils/subject_validation.dart';
import 'package:timetable/features/subjects/widgets/color.dart';
import 'package:timetable/features/subjects/widgets/day_time_week_tb_config.dart';
import 'package:timetable/features/subjects/widgets/label_location.dart';
import 'package:timetable/features/subjects/widgets/note.dart';
import 'package:timetable/core/constants/days.dart';
import 'package:timetable/core/constants/rotation_weeks.dart';
import 'package:timetable/core/db/database.dart';
import 'package:timetable/core/utils/time_management.dart';
import 'package:timetable/features/subjects/providers/overlapping_subjects.dart';
import 'package:timetable/features/settings/providers/settings.dart';
import 'package:timetable/features/subjects/providers/subjects.dart';
import 'package:timetable/features/timetable/providers/timetables.dart';

/// Subject creation/modification UI.
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
    final overlappingSubjects = ref.watch(overlappingSubjectsProvider);
    final autoCompleteColor = ref.watch(settingsProvider).autoCompleteColor;
    final timetables = ref.watch(timetableProvider);
    final tfHours = ref.watch(settingsProvider).twentyFourHours;
    final customStartTimeHour =
        ref.watch(settingsProvider).customStartTime.hour;
    final defaultSubjectDuration =
        ref.watch(settingsProvider).defaultSubjectDuration;

    final bool isSubjectNull = (subject == null);
    final bool isCurrentTimetableNull = (currentTimetable == null);
    final int id = (isSubjectNull ? subjects.length : subject!.id);
    final int baseHour = rowIndex! + (tfHours ? 0 : customStartTimeHour);

    final ValueNotifier<TimetableData?> timetable = useState(
      isSubjectNull
          ? isCurrentTimetableNull
              ? timetables
                  .where((t) => t.name == subject!.timetable)
                  .firstOrNull
              : currentTimetable!.value
          : timetables.where((t) => t.name == subject!.timetable).firstOrNull,
    );
    final ValueNotifier<TimeOfDay> startTime = useState(
      TimeOfDay(hour: subject?.startTime.hour ?? baseHour, minute: 0),
    );
    final ValueNotifier<TimeOfDay> endTime = useState(
      TimeOfDay(
        hour:
            subject?.endTime.hour ?? baseHour + defaultSubjectDuration.inHours,
        minute: 0,
      ),
    );

    final ValueNotifier<String> label = useState(subject?.label ?? "");
    final ValueNotifier<String?> location = useState(subject?.location ?? "");
    final ValueNotifier<String?> note = useState(subject?.note ?? "");
    final ValueNotifier<Days> day =
        useState(Days.values[subject?.day.index ?? columnIndex!]);
    final ValueNotifier<Color> color = useState(subject?.color ?? Colors.black);
    final ValueNotifier<RotationWeeks> rotationWeek =
        useState(subject?.rotationWeek ?? RotationWeeks.none);

    // I DONT KNOW WHY I AM USING [SubjectData] I SHOULD BE USING [SubjectCompanion]
    // update: using [SubjectCompanion] breaks a lot of stuff so i will not be using that
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

    final validation = SubjectValidation(
      subjectsInSameDay: subjects.where((e) => e.day == day.value).toList(),
      inputHours: getHoursList(startTime.value, endTime.value),
      newSubject: newSubject,
      currentSubject: subject,
      overlappingSubjects: overlappingSubjects,
    );

    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                shadowColor: Colors.transparent,
                backgroundColor:
                    Theme.of(context).colorScheme.onPrimaryContainer,
                foregroundColor:
                    Theme.of(context).colorScheme.secondaryContainer,
                iconColor: Theme.of(context).colorScheme.secondaryContainer,
              ),
              onPressed: () async {
                if (!formKey.currentState!.validate()) return;

                final hasConflitcs = isSubjectNull
                    ? validation.hasConflicts
                    : validation.hasConflictsForExisting;

                if (hasConflitcs) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('time_slots_occupied_error').tr(),
                    ),
                  );
                  return;
                }

                final navigator = Navigator.of(context);
                final subjectNotifier = ref.watch(subjectProvider.notifier);

                if (isSubjectNull) {
                  await subjectNotifier
                      .addSubject(newSubject.toCompanion(true))
                      .then((_) => navigator.pop(newSubject));
                }
                if (!isSubjectNull) {
                  await subjectNotifier
                      .updateSubject(newSubject)
                      .then((_) => navigator.pop(newSubject));
                }
              },
              icon: Icon(
                isSubjectNull ? Icons.add_outlined : Icons.save_outlined,
              ),
              label: Text(isSubjectNull ? "create" : "save").tr(),
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
                      ? validation.hasConflicts
                      : validation.hasConflictsForExisting,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: NotesTile(note: note),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
