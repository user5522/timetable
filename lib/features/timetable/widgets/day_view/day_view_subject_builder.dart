import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:timetable/core/db/database.dart';
import 'package:timetable/features/settings/providers/settings.dart';
import 'package:timetable/features/subjects/screens/subject_screen.dart';

/// Subject builder for the day view.
class DayViewSubjectBuilder extends ConsumerWidget {
  final Subject subject;

  const DayViewSubjectBuilder({super.key, required this.subject});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rotationWeeks = ref.watch(settingsProvider).rotationWeeks;
    final hideTransparentSubject =
        ref.watch(settingsProvider).hideTransparentSubject;
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

    final hideTransparentSubjects =
        hideTransparentSubject && color.a == Colors.transparent.a;

    if (!hideTransparentSubjects) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SubjectScreen(
                  subject: subject,
                ),
              ),
            );
          },
          borderRadius: BorderRadius.circular(10),
          child: Ink(
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Colors.black,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
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
                      // SizedBox is for incase the label is too long
                      const SizedBox(
                        width: 20,
                      ),
                      if (rotationWeeks)
                        Text(
                          subject.rotationWeek.displayName,
                          style: TextStyle(
                            color: labelColor,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    ],
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
                      padding: EdgeInsets.symmetric(vertical: 5),
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
                    )
                ],
              ),
            ),
          ),
        ),
      );
    }
    return Container();
  }
}
