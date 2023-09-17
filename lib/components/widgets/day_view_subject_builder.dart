import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:timetable/constants/rotation_weeks.dart';
import 'package:timetable/models/settings.dart';
import 'package:timetable/models/subjects.dart';
import 'package:timetable/screens/cell_screen.dart';

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
        ? Colors.black.withOpacity(.6)
        : Colors.white.withOpacity(.75);

    String label = subject.label;
    String? location = subject.location;
    Color color = subject.color;

    final hideTransparentSubjects =
        hideTransparentSubject && color.opacity == Colors.transparent.opacity;

    if (!hideTransparentSubjects) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                settings: const RouteSettings(
                  name: "CellScreen",
                ),
                builder: (context) => CellScreen(
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
                      Text(
                        label.length > (27)
                            ? '${label.substring(0, (27))}..'
                            : label,
                        style: TextStyle(
                          color: labelColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (rotationWeeks)
                        Text(
                          getSubjectRotationWeekLabel(subject),
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
                  if (location != "")
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 19,
                          color: subLabelsColor,
                        ),
                        Text(
                          location.toString().length > (22)
                              ? '${location.toString().substring(0, (22))}..'
                              : location.toString(),
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
            ),
          ),
        ),
      );
    } else {
      return Container();
    }
  }
}
