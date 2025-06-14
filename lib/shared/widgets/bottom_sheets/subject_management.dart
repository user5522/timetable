import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:timetable/features/subjects/screens/subject_screen.dart';
import 'package:timetable/shared/widgets/alert_dialog.dart';
import 'package:timetable/shared/widgets/color_indicator.dart';
import 'package:timetable/core/db/database.dart';
import 'package:timetable/core/utils/rotation_weeks.dart';
import 'package:timetable/features/subjects/providers/overlapping_subjects.dart';
import 'package:timetable/features/settings/providers/settings.dart';
import 'package:timetable/features/subjects/providers/subjects.dart';
import 'package:timetable/features/timetable/providers/timetables.dart';

/// Bottom sheet widget to quickly see the full subject properties
class SubjectManagementBottomSheet extends ConsumerWidget {
  final Subject subject;

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
    final multipleTimetables = ref.watch(settingsProvider).multipleTimetables;
    final customStartTime = ref.watch(settingsProvider).customStartTime;
    final subjects = ref.watch(subjectProvider);
    final currentSubject = subjects.firstWhere((s) => s.id == subject.id);

    Color labelColor = Theme.of(context).textTheme.titleMedium!.color!;
    Color subLabelsColor =
        Theme.of(context).textTheme.titleMedium!.color!.withAlpha(720);

    String label = currentSubject.label;
    String? location = currentSubject.location;
    Color color = currentSubject.color;
    String? note = currentSubject.note;

    final bool locationCheck = location != null && location.isNotEmpty;
    final bool noteCheck = note != null && note.isNotEmpty;

    final inOverlappingSubjectsCheck = () {
      for (var couple in overlappingSubjects) {
        if (couple.contains(currentSubject)) return true;
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
                    padding: const EdgeInsets.only(right: 20),
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
              const Padding(padding: EdgeInsets.symmetric(vertical: 6)),
              Row(
                children: [
                  const Padding(padding: EdgeInsets.only(right: 40)),
                  Expanded(
                      child: Text(
                    currentSubject.day.name,
                    style: TextStyle(
                      color: subLabelsColor,
                      fontSize: 17,
                    ),
                  ).tr()),
                ],
              ),
              const Padding(padding: EdgeInsets.symmetric(vertical: 2.5)),
              Row(
                children: [
                  const Padding(padding: EdgeInsets.only(right: 40)),
                  Text(
                    "${currentSubject.startTime.hour.toString()}:00",
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
                    "${currentSubject.endTime.hour.toString()}:00",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      color: subLabelsColor,
                    ),
                  ),
                ],
              ),
              const Padding(padding: EdgeInsets.symmetric(vertical: 2.5)),
              if (locationCheck || noteCheck) const Divider(indent: 40),
              if (locationCheck)
                Row(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(right: 18, top: 10, bottom: 10),
                      child: Icon(
                        Icons.location_on_outlined,
                        size: 22,
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
                          color: subLabelsColor,
                        ),
                      ),
                    ),
                  ],
                ),
              if (locationCheck && noteCheck) const Divider(indent: 40),
              if (noteCheck)
                Row(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(right: 18, top: 10, bottom: 10),
                      child: Icon(
                        Icons.sticky_note_2_outlined,
                        size: 22,
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
                          color: subLabelsColor,
                        ),
                      ),
                    ),
                  ],
                ),
              if (rotationWeeks || multipleTimetables) const Divider(),
              if (rotationWeeks || multipleTimetables)
                IntrinsicHeight(
                  child: Row(
                    children: [
                      if (rotationWeeks)
                        Padding(
                          padding: const EdgeInsets.only(
                            right: 18,
                            top: 10,
                            bottom: 10,
                          ),
                          child: Icon(
                            Icons.screen_rotation_alt_outlined,
                            size: 22,
                            color: subLabelsColor,
                          ),
                        ),
                      if (rotationWeeks)
                        Expanded(
                          child: Text(
                            getRotationWeekLabel(currentSubject.rotationWeek),
                            style: TextStyle(
                              color: subLabelsColor,
                              fontSize: 17,
                            ),
                          ),
                        ),
                      if (rotationWeeks && multipleTimetables)
                        const Padding(
                          padding: EdgeInsets.only(right: 10),
                          child: VerticalDivider(),
                        ),
                      if (multipleTimetables)
                        Padding(
                          padding: const EdgeInsets.only(
                            right: 18,
                            top: 10,
                            bottom: 10,
                          ),
                          child: Icon(
                            Icons.table_view_outlined,
                            size: 22,
                            color: subLabelsColor,
                          ),
                        ),
                      if (multipleTimetables)
                        Expanded(
                          child: Text(
                            "${"timetable".plural(1)} ${currentSubject.timetable}",
                            style: TextStyle(
                              color: subLabelsColor,
                              fontSize: 17,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        if (!inOverlappingSubjectsCheck)
          const Divider(indent: 16, endIndent: 16, height: 0),
        if (!inOverlappingSubjectsCheck)
          ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SubjectScreen(
                    rowIndex:
                        currentSubject.startTime.hour - customStartTime.hour,
                    columnIndex: currentSubject.day.index,
                    currentTimetable: ValueNotifier(
                      timetables.firstWhere(
                        (e) => e.name == currentSubject.timetable,
                      ),
                    ),
                  ),
                ),
              );
            },
            leading: const Icon(Icons.add_outlined),
            title: const Text("add").tr(),
          ),
        Divider(
          indent: !inOverlappingSubjectsCheck ? 56 : 16,
          endIndent: 16,
          height: 0,
        ),
        ListTile(
          onTap: () async {
            final updatedSubject = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SubjectScreen(subject: currentSubject),
              ),
            );

            if (updatedSubject != null) {
              await subjectNotifier.updateSubject(updatedSubject);
            }
          },
          horizontalTitleGap: 16,
          leading: const Icon(Icons.edit_outlined),
          title: const Text("edit").tr(),
        ),
        const Divider(indent: 56, endIndent: 16, height: 0),
        ListTile(
          onTap: () async {
            final navigator = Navigator.of(context);
            final messenger = ScaffoldMessenger.of(context);

            try {
              if (subjects.any((s) => s.id == currentSubject.id)) {
                navigator.pop();
                final result = await showDialog<bool>(
                      context: context,
                      builder: (BuildContext context) {
                        return ShowAlertDialog(
                          content: const Text('delete_subject_dialog').tr(),
                          approveButtonText: "delete".tr(),
                          onCancel: () => Navigator.of(context).pop(false),
                          onApprove: () => Navigator.of(context).pop(true),
                        );
                      },
                    ) ??
                    false;

                if (result) {
                  await subjectNotifier.deleteSubject(currentSubject);
                  messenger.showSnackBar(
                    SnackBar(
                      content: const Text('subject_deleted_snackbar').tr(),
                      duration: const Duration(seconds: 3),
                      action: SnackBarAction(
                        label: "undo",
                        onPressed: () => subjectNotifier
                            .addSubject(currentSubject.toCompanion(true)),
                      ),
                    ),
                  );
                }
              }
            } catch (e) {
              messenger.showSnackBar(
                SnackBar(
                  content: Text('error: $e'),
                ),
              );
            }
          },
          horizontalTitleGap: 16,
          leading: const Icon(Icons.delete_outlined),
          title: const Text("delete").tr(),
        ),
        const SizedBox(height: 30),
      ],
    );
  }
}
