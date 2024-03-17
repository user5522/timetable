import 'package:flutter/material.dart';
import 'package:timetable/components/widgets/subject_data_bottom_sheet.dart';
import 'package:timetable/constants/rotation_weeks.dart';
import 'package:timetable/helpers/rotation_weeks.dart';

/// Bottom Sheet Modal Widget used to select a subject's rotation week.
class RotationWeekModalBottomSheet extends StatelessWidget {
  final List<RotationWeeks> rotationWeeks;
  final ValueNotifier<RotationWeeks> rotationWeek;

  const RotationWeekModalBottomSheet({
    super.key,
    required this.rotationWeeks,
    required this.rotationWeek,
  });

  @override
  Widget build(BuildContext context) {
    return SubjectDataBottomSheet(
      title: "Rotation weeks",
      children: rotationWeeks.where((r) => r != RotationWeeks.all).map(
        (r) {
          bool isSelected = (r == rotationWeek.value);

          return ListTile(
            title: Row(
              children: [
                Text(
                  getRotationWeekLabel(r),
                ),
                const Spacer(),
                Visibility(
                  visible: isSelected,
                  child: const Icon(
                    Icons.check,
                  ),
                ),
              ],
            ),
            visualDensity: VisualDensity.compact,
            onTap: () {
              rotationWeek.value = r;
              Navigator.pop(context);
            },
          );
        },
      ).toList(),
    );
  }
}
