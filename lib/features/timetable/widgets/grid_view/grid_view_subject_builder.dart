import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:non_uniform_border/non_uniform_border.dart';
import 'package:timetable/shared/providers/day.dart';
import 'package:timetable/shared/widgets/bottom_sheets/subject_management.dart';
import 'package:timetable/core/constants/custom_times.dart';
import 'package:timetable/core/utils/rotation_weeks.dart';
import 'package:timetable/core/db/database.dart';
import 'package:timetable/features/settings/providers/settings.dart';

/// Subject builder for the grid view.
/// also builds for the overlapping subjects with some visual tweaks
class SubjectBuilder extends ConsumerWidget {
  final Subject subject;
  final bool isOverlapping;
  final int startTimeOffset;

  const SubjectBuilder({
    super.key,
    required this.subject,
    this.isOverlapping = false,
    this.startTimeOffset = 0,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hideLocation = ref.watch(settingsProvider).hideLocation;
    final customStartTime = ref.watch(settingsProvider).customStartTime;
    final customEndTime = ref.watch(settingsProvider).customEndTime;
    final rotationWeeks = ref.watch(settingsProvider).rotationWeeks;
    final hideTransparentSubject =
        ref.watch(settingsProvider).hideTransparentSubject;
    final compactMode = ref.watch(settingsProvider).compactMode;
    final weekStartDay = ref.watch(settingsProvider).weekStartDay;
    final orderedDays = ref.watch(orderedDaysProvider);
    final bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    String label = subject.label;
    String? location = subject.location;
    Color color = subject.color;
    int subjHeight = subject.endTime.hour - subject.startTime.hour;

    final hideTransparentSubjects =
        hideTransparentSubject && (color.a == Colors.transparent.a);

    Color labelColor =
        color.computeLuminance() > .7 ? Colors.black : Colors.white;
    Color subLabelsColor = color.computeLuminance() > .7
        ? Colors.black.withValues(alpha: .6)
        : Colors.white.withValues(alpha: .75);

    final shape = NonUniformBorder(
      leftWidth: subject.day.index == weekStartDay ? 0 : 1,
      rightWidth: subject.day.index == (orderedDays.length - 1) ? 0 : 1,
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

    int quarterTurns = compactMode && isPortrait && isOverlapping ? 1 : 0;

    return !isOverlapping
        ? Container(
            decoration: ShapeDecoration(shape: shape),
            padding: const EdgeInsets.all(2),
            child: buildSubjectContent(
              context,
              quarterTurns,
              labelColor,
              subLabelsColor,
              label,
              location,
              color,
              hideTransparentSubjects,
              subjHeight,
              compactMode,
              isPortrait,
              hideLocation,
              rotationWeeks,
            ),
          )
        : buildSubjectContent(
            context,
            quarterTurns,
            labelColor,
            subLabelsColor,
            label,
            location,
            color,
            hideTransparentSubjects,
            subjHeight,
            compactMode,
            isPortrait,
            hideLocation,
            rotationWeeks,
          );
  }

  Widget buildSubjectContent(
    BuildContext context,
    int quarterTurns,
    Color labelColor,
    Color subLabelsColor,
    String label,
    String? location,
    Color color,
    bool hideTransparentSubjects,
    int subjHeight,
    bool compactMode,
    bool isPortrait,
    bool hideLocation,
    bool rotationWeeks,
  ) {
    return InkWell(
      onTap: () {
        showModalBottomSheet(
          showDragHandle: true,
          enableDrag: true,
          isDismissible: true,
          isScrollControlled: true,
          context: context,
          builder: (context) {
            return Wrap(
              children: [
                SubjectManagementBottomSheet(subject: subject),
              ],
            );
          },
        );
      },
      borderRadius: BorderRadius.circular(5),
      // odd numbers, i know, but i had to make sure both are aligned perfectly
      child: Ink(
        padding: EdgeInsets.fromLTRB(
          compactMode && isPortrait && isOverlapping ? 1 : 3,
          isOverlapping ? 8.25 : 3,
          compactMode && isPortrait && isOverlapping ? 1 : 3,
          3,
        ),
        decoration: BoxDecoration(
          color: color,
          border: Border.all(
            color: hideTransparentSubjects ? Colors.transparent : Colors.black,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!hideTransparentSubjects)
              RotatedBox(
                quarterTurns: quarterTurns,
                child: Text(
                  compactMode && isPortrait && isOverlapping
                      ? label.length > (subjHeight * 5)
                          ? '${label.substring(0, (subjHeight * 5))}..'
                          : label
                      : label,
                  maxLines: compactMode && isPortrait && isOverlapping
                      ? 1
                      : subjHeight * 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: labelColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            SizedBox(
              height: compactMode && isPortrait && isOverlapping ? 8 : 5,
            ),
            if (location != null && (!hideLocation || !hideTransparentSubjects))
              RotatedBox(
                quarterTurns: quarterTurns,
                child: Text(
                  compactMode && !isPortrait && isOverlapping
                      ? location.length > (subjHeight * 5)
                          ? '${location.substring(0, (subjHeight * 5))}..'
                          : location
                      : location,
                  maxLines: compactMode && isPortrait && isOverlapping
                      ? 1
                      : subjHeight,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: subLabelsColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            if (rotationWeeks) const Spacer(),
            if (rotationWeeks && !hideTransparentSubjects)
              Align(
                alignment: Alignment.bottomRight,
                child: RotatedBox(
                  quarterTurns: quarterTurns,
                  child: Text(
                    getSubjectRotationWeekLabel(subject),
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
    );
  }
}
