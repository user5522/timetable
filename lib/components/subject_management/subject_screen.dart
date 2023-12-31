import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:timetable/components/subject_management/subject_configs/colors_config.dart';
import 'package:timetable/components/subject_management/subject_configs/day_time_week_config.dart';
import 'package:timetable/components/subject_management/subject_configs/note_tile.dart';
import 'package:timetable/components/widgets/list_tile_group.dart';
import 'package:timetable/constants/basic_subject.dart';
import 'package:timetable/constants/days.dart';
import 'package:timetable/constants/rotation_weeks.dart';
import 'package:timetable/db/database.dart';
import 'package:timetable/provider/overlapping_subjects.dart';
import 'package:timetable/provider/settings.dart';
import 'package:timetable/provider/subjects.dart';

/// The Subject creation/modification screen.
/// Uses [TimeDayRotationWeekConfig], [NotesTile] and [ColorsConfig]
class SubjectScreen extends HookConsumerWidget {
  final int? rowIndex;
  final int? columnIndex;
  final SubjectData? subject;

  const SubjectScreen({
    super.key,
    this.rowIndex,
    this.columnIndex,
    this.subject,
  });

  static final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subjects = ref.watch(subjProvider);
    final subjectNotifier = ref.watch(subjProvider.notifier);
    final overlappingSubjects = ref.watch(overlappingSubjectsProvider);
    final autoCompleteColor = ref.watch(settingsProvider).autoCompleteColor;

    final bool isSubjectNull = subject == null;
    final int id = isSubjectNull ? subjects.length : subject!.id;
    final startTime = useState(
      TimeOfDay(
        hour: isSubjectNull ? (rowIndex! + 8) : subject!.startTime.hour,
        minute: 0,
      ),
    );
    final endTime = useState(
      TimeOfDay(
        hour: isSubjectNull ? (rowIndex! + 8 + 1) : subject!.endTime.hour,
        minute: 0,
      ),
    );

    final day = useState(
        Days.values[isSubjectNull ? columnIndex! : subject!.day.index]);
    final rotationWeek =
        useState(isSubjectNull ? RotationWeeks.none : subject!.rotationWeek);
    final color = useState(isSubjectNull ? Colors.black : subject!.color);

    final label = useState(subject?.label ?? "");
    final location = useState(subject?.location ?? "");
    final note = useState(subject?.note ?? "");

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
    );

    final subjectsInSameDay = subjects
        .where(
          (e) => e.day == day.value,
        )
        .toList();

    final isOccupied = subjectsInSameDay
        .where((e) => overlappingSubjects.any((elem) => elem.contains(e)))
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
                  if (isSubjectNull) {
                    if (!isOccupied) {
                      subjectNotifier.addSubject(newSubject.toCompanion(false));
                      Navigator.pop(context, label.value);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Time slots are already occupied!'),
                        ),
                      );
                    }
                  } else {
                    if (!isOccupiedExceptSelf) {
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
                ListTileGroup(
                  children: [
                    ListItem(
                      title: TextFormField(
                        initialValue: label.value,
                        decoration: const InputDecoration(
                          hintText: "Subject",
                          border: InputBorder.none,
                        ),
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
                        initialValue: location.value,
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
                TimeDayRotationWeekConfig(
                  day: day,
                  rotationWeek: rotationWeek,
                  startTime: startTime,
                  endTime: endTime,
                  occupied: isSubjectNull ? isOccupied : isOccupiedExceptSelf,
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
