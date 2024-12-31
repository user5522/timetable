import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:timetable/components/subject_management/subject_screen.dart';
import 'package:timetable/components/widgets/color_indicator.dart';
import 'package:timetable/db/database.dart';
import 'package:timetable/helpers/rotation_weeks.dart';
import 'package:timetable/provider/overlapping_subjects.dart';
import 'package:timetable/provider/settings.dart';
import 'package:timetable/provider/subjects.dart';
import 'package:timetable/provider/timetables.dart';

/// Bottom sheet widget to quickly see the full subject properties
class SubjectManagementBottomSheet extends ConsumerWidget {
  final SubjectData subject;

  const SubjectManagementBottomSheet({
    super.key,
    required this.subject,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subjectNotifier = ref.watch(subjectProvider.notifier);
    final overlappingSubjects = ref.watch(overlappingSubjectsProvider);
    final timetables = ref.watch(timetableProvider);
    final rotationWeeks = ref.watch(settingsProvider).rotationWeeks;
    final customStartTime = ref.watch(settingsProvider).customStartTime;

    Color labelColor =
        subject.color.computeLuminance() > .7 ? Colors.black : Colors.white;
    Color subLabelsColor = subject.color.computeLuminance() > .7
        ? Colors.black.withValues(alpha: .6)
        : Colors.white.withValues(alpha: .75);

    String label = subject.label;
    String? location = subject.location;
    Color color = subject.color;
    String? note = subject.note;

    final bool locationCheck = location != null && location.isNotEmpty;
    final bool noteCheck = note != null && note.isNotEmpty;

    final inOverlappingSubjectsCheck = () {
      for (var couple in overlappingSubjects) {
        if (couple.contains(subject)) return true;
      }
      return false;
    }();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: ColorIndicator(color: color),
                  ),
                  Expanded(
                    child: Text(
                      label,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: labelColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 2.5),
              ),
              const Divider(),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 2.5),
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Icon(
                      Icons.schedule_outlined,
                      size: 19,
                      color: subLabelsColor,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        "${subject.startTime.hour.toString()}:00",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                          color: subLabelsColor,
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_rounded,
                        size: 20,
                        color: subLabelsColor,
                      ),
                      Text(
                        "${subject.endTime.hour.toString()}:00",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                          color: subLabelsColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 2.5),
              ),
              if (locationCheck)
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Icon(
                        Icons.location_on_outlined,
                        size: 19,
                        color: subLabelsColor,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        location.toString(),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                          color: subLabelsColor,
                        ),
                      ),
                    ),
                  ],
                ),
              if (locationCheck && noteCheck)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 2.5),
                ),
              if (noteCheck)
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Icon(
                        Icons.sticky_note_2_outlined,
                        size: 19,
                        color: subLabelsColor,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        note.toString(),
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                          color: subLabelsColor,
                        ),
                      ),
                    ),
                  ],
                ),
              if (rotationWeeks && noteCheck)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 2.5),
                ),
              if (rotationWeeks)
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Icon(
                        Icons.screen_rotation_alt_outlined,
                        size: 19,
                        color: subLabelsColor,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        getRotationWeekLabel(subject.rotationWeek),
                        style: TextStyle(
                          color: subLabelsColor,
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
        if (!inOverlappingSubjectsCheck)
          ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SubjectScreen(
                    rowIndex: subject.startTime.hour - customStartTime.hour,
                    columnIndex: subject.day.index,
                    currentTimetable: ValueNotifier(
                      timetables.firstWhere((e) => e.name == subject.timetable),
                    ),
                  ),
                ),
              );
            },
            leading: const Icon(Icons.add_outlined),
            title: const Text("add").tr(),
          ),
        ListTile(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SubjectScreen(subject: subject),
              ),
            );
          },
          leading: const Icon(Icons.edit_outlined),
          title: const Text("edit").tr(),
        ),
        ListTile(
          onTap: () async {
            final navigator = Navigator.of(context);
            final messenger = ScaffoldMessenger.of(context);

            await subjectNotifier.deleteSubject(subject).then(
              (_) {
                navigator.pop();
                messenger.showSnackBar(
                  SnackBar(
                    content: const Text('subject_deleted_snackbar').tr(),
                  ),
                );
              },
            );
          },
          leading: const Icon(Icons.delete_outlined),
          title: const Text("delete").tr(),
        )
      ],
    );
  }
}
