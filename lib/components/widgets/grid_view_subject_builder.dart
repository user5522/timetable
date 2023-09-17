import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:non_uniform_border/non_uniform_border.dart';
import 'package:timetable/constants/custom_times.dart';
import 'package:timetable/constants/rotation_weeks.dart';
import 'package:timetable/models/settings.dart';
import 'package:timetable/models/subjects.dart';
import 'package:timetable/screens/cell_screen.dart';
import 'package:timetable/constants/grid_properties.dart';

class SubjectBuilder extends ConsumerWidget {
  final Subject subject;

  const SubjectBuilder({
    super.key,
    required this.subject,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hideLocation = ref.watch(settingsProvider).hideLocation;
    final customStartTime = ref.watch(settingsProvider).customStartTime;
    final customEndTime = ref.watch(settingsProvider).customEndTime;
    final rotationWeeks = ref.watch(settingsProvider).rotationWeeks;

    String label = subject.label;
    String? location = subject.location;
    Color color = subject.color;

    Color labelColor =
        color.computeLuminance() > .7 ? Colors.black : Colors.white;
    Color subLabelsColor = color.computeLuminance() > .7
        ? Colors.black.withOpacity(.6)
        : Colors.white.withOpacity(.75);

    final shape = NonUniformBorder(
      leftWidth: subject.day.index == 0 ? 0 : 1,
      rightWidth: subject.day.index == (columns(ref) - 1) ? 0 : 1,
      topWidth: subject.startTime.hour ==
              getCustomStartTime(customStartTime, ref).hour
          ? 0
          : 1,
      bottomWidth:
          subject.endTime.hour == getCustomEndTime(customEndTime, ref).hour
              ? 0
              : 1,
      strokeAlign: BorderSide.strokeAlignCenter,
      color: Colors.grey,
    );

    return Container(
      decoration: ShapeDecoration(shape: shape),
      child: Padding(
        padding: const EdgeInsets.all(2),
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
          borderRadius: BorderRadius.circular(5),
          child: Ink(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: color,
              border: Border.all(
                color: Colors.black,
                width: 1,
              ),
              borderRadius: const BorderRadius.all(
                Radius.circular(5),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  maxLines: (subject.endTime.hour - subject.startTime.hour == 1
                      ? 2
                      : 5),
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: labelColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                if ((location != null))
                  if (hideLocation == false)
                    Text(
                      location.toString(),
                      maxLines:
                          (subject.endTime.hour - subject.startTime.hour == 1
                              ? 2
                              : 3),
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: subLabelsColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                if (rotationWeeks)
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      getSubjectRotationWeekLabel(subject),
                      style: TextStyle(
                        color: subLabelsColor,
                        fontWeight: FontWeight.bold,
                      ),
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
