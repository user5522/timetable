import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:non_uniform_border/non_uniform_border.dart';
import 'package:timetable/constants/custom_times.dart';
import 'package:timetable/constants/grid_properties.dart';
import 'package:timetable/helpers/rotation_weeks.dart';
import 'package:timetable/db/database.dart';
import 'package:timetable/provider/settings.dart';
import 'package:timetable/components/subject_management/subject_screen.dart';

/// Overlapping Subjects Builder for the grid view.
class OverlappingSubjBuilder extends ConsumerWidget {
  final List<SubjectData> subjects;
  final int earlierStartTimeHour;
  final int laterEndTimeHour;

  const OverlappingSubjBuilder({
    super.key,
    required this.subjects,
    required this.earlierStartTimeHour,
    required this.laterEndTimeHour,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customStartTime = ref.watch(settingsProvider).customStartTime;
    final customEndTime = ref.watch(settingsProvider).customEndTime;
    final compactMode = ref.watch(settingsProvider).compactMode;
    final hideLocation = ref.watch(settingsProvider).hideLocation;
    final rotationWeeks = ref.watch(settingsProvider).rotationWeeks;
    final hideTransparentSubject =
        ref.watch(settingsProvider).hideTransparentSubject;

    double screenWidth = MediaQuery.of(context).size.width;
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    double tileHeight = compactMode ? 125 : 100;
    double tileWidth = compactMode
        ? (screenWidth / columns(ref) - ((timeColumnWidth + 10) / 10))
        : isPortrait
            ? 100
            : (screenWidth / columns(ref) - ((timeColumnWidth + 10) / 10));

    final shape = NonUniformBorder(
      leftWidth: subjects[0].day.index == 0 ? 0 : 1,
      rightWidth: subjects[0].day.index == (columns(ref) - 1) ? 0 : 1,
      topWidth:
          earlierStartTimeHour == getCustomStartTime(customStartTime, ref).hour
              ? 0
              : 1,
      bottomWidth:
          laterEndTimeHour == getCustomEndTime(customEndTime, ref).hour ? 0 : 1,
      strokeAlign: BorderSide.strokeAlignCenter,
      color: Colors.grey,
    );

    const double outerPadding = 2;

    return Container(
      decoration: ShapeDecoration(
        shape: shape,
      ),
      child: Row(
        children: List.generate(subjects.length, (i) {
          Color labelColor = subjects[i].color.computeLuminance() > .7
              ? Colors.black
              : Colors.white;
          Color subLabelsColor = subjects[i].color.computeLuminance() > .7
              ? Colors.black.withOpacity(.6)
              : Colors.white.withOpacity(.75);

          int endTimeHour = subjects[i].endTime.hour;
          int startTimeHour = subjects[i].startTime.hour;
          String label = subjects[i].label;
          String? location = subjects[i].location;
          Color color = subjects[i].color;

          int subjHeight = endTimeHour - startTimeHour;

          final hideTransparentSubjects =
              hideTransparentSubject && color.opacity == 0;

          return Column(
            children: [
              Container(
                height: (startTimeHour - earlierStartTimeHour) * (tileHeight),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  outerPadding,
                  outerPadding,
                  outerPadding,
                  outerPadding - 1,
                ),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        settings: const RouteSettings(
                          name: "CellScreen",
                        ),
                        builder: (context) => SubjectScreen(
                          subject: subjects[i],
                        ),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(5),
                  child: Ink(
                    padding: EdgeInsets.fromLTRB(
                        compactMode ? 1 : 2, 5, compactMode ? 1 : 2, 5),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                        color: hideTransparentSubjects
                            ? Colors.transparent
                            : Colors.black,
                        width: 0,
                      ),
                    ),
                    width: ((tileWidth / subjects.length) - .75) -
                        (outerPadding * 2.25),
                    height:
                        (((endTimeHour - startTimeHour) * (tileHeight)) - 1) -
                            (outerPadding * 2),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (!hideTransparentSubjects)
                          RotatedBox(
                            quarterTurns: compactMode ? 1 : 0,
                            child: Text(
                              compactMode
                                  ? label.length > (subjHeight * 5)
                                      ? '${label.substring(0, (subjHeight * 5))}..'
                                      : label
                                  : label,
                              maxLines: compactMode ? 1 : subjHeight * 2,
                              style: TextStyle(
                                color: labelColor,
                                fontWeight: FontWeight.bold,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        SizedBox(
                          height: compactMode ? 8 : 5,
                        ),
                        if ((location != null))
                          if (!hideLocation)
                            if (!hideTransparentSubjects)
                              RotatedBox(
                                quarterTurns: compactMode ? 1 : 0,
                                child: Text(
                                  compactMode
                                      ? location.length > (subjHeight * 5)
                                          ? '${location.substring(0, (subjHeight * 5))}..'
                                          : location
                                      : location,
                                  maxLines: compactMode ? 1 : subjHeight,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: subLabelsColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                        if (rotationWeeks) const Spacer(),
                        if (rotationWeeks)
                          if (!hideTransparentSubjects)
                            Align(
                              alignment: Alignment.bottomRight,
                              child: RotatedBox(
                                quarterTurns: compactMode ? 1 : 0,
                                child: Text(
                                  getSubjectRotationWeekLabel(subjects[i]),
                                  style: TextStyle(
                                    color: subLabelsColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
