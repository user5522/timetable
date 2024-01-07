import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:timetable/components/subject_management/subject_configs/colors_config.dart';
import 'package:timetable/components/subject_management/subject_configs/day_time_week_tb_config.dart';
import 'package:timetable/components/subject_management/subject_configs/note_tile.dart';
import 'package:timetable/components/widgets/list_item_group.dart';
import 'package:timetable/constants/basic_subject.dart';
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
    final customStartTimeHour =
        ref.watch(settingsProvider).customStartTime.hour;
    final focus = FocusNode();

    final bool isSubjectNull = (subject == null);
    final int id = isSubjectNull ? subjects.length : subject!.id;

    final timetable = useState(
      isSubjectNull
          ? currentTimetable!.value
          : timetables.where((t) => t.name == subject!.timetable).firstOrNull,
    );
    final startTime = useState(
      TimeOfDay(
        hour: subject?.startTime.hour ?? (rowIndex! + customStartTimeHour),
        minute: 0,
      ),
    );
    final ValueNotifier<TimeOfDay> endTime = useState(
      TimeOfDay(
        hour: subject?.endTime.hour ?? (rowIndex! + customStartTimeHour + 1),
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
                  const SnackBar(
                    content: Text('Subject Deleted!'),
                  ),
                );
                Navigator.pop(context);
              },
              child: const Text("Delete"),
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
                if (formKey.currentState!.validate()) {
                  if (!isSubjectNull) {
                    if (!isOccupiedExceptSelf && !multipleOccupied) {
                      subjectNotifier.updateSubject(newSubject);
                      Navigator.pop(context, label.value);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Time slots are already occupied!'),
                        ),
                      );
                    }
                  }
                  if (isSubjectNull) {
                    if (!isOccupied && !multipleOccupied) {
                      subjectNotifier.addSubject(newSubject.toCompanion(false));
                      Navigator.pop(context, label.value);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Time slots are already occupied!'),
                        ),
                      );
                    }
                  }
                }
              },
              child: Text(isSubjectNull ? "Create" : "Save"),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListItemGroup(
                  children: [
                    ListItem(
                      title: TextFormField(
                        initialValue: label.value,
                        autofocus: true,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          hintText: "Subject",
                          border: InputBorder.none,
                        ),
                        onFieldSubmitted: (v) {
                          FocusScope.of(context).requestFocus(focus);
                        },
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter a Subject.';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          label.value = value;
                          if (autoCompleteColor) {
                            color.value = subjects
                                .firstWhere(
                                  (subj) =>
                                      label.value.toLowerCase().trim() ==
                                      subj.label.toLowerCase().trim(),
                                  orElse: () => basicSubject,
                                )
                                .color;
                          }
                        },
                      ),
                    ),
                    ListItem(
                      title: TextFormField(
                        focusNode: focus,
                        initialValue: location.value,
                        textInputAction: TextInputAction.done,
                        decoration: const InputDecoration(
                          hintText: "Location",
                          border: InputBorder.none,
                        ),
                        onChanged: (value) {
                          location.value = value;
                        },
                      ),
                    ),
                  ],
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
        ),
      ),
    );
  }
}
