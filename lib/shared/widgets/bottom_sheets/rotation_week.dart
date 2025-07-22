import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:timetable/shared/widgets/bottom_sheets/subject_data.dart';
import 'package:timetable/core/constants/rotation_weeks.dart';
import 'package:timetable/core/utils/rotation_weeks.dart';

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
    /// actual usable rotation weeks
    final rws = rotationWeeks.where((r) => r != RotationWeeks.none).toList();

    return SubjectDataBottomSheet(
      title: "rotation_week".plural(2),
      children: List.generate(rws.length, (i) {
        final rw = rws[i];
        bool isSelected = (rw == rotationWeek.value);

        return ListTile(
          title: Row(
            children: [
              Text(getRotationWeekLabel(rw)),
              const Spacer(),
              Visibility(
                visible: isSelected,
                child: const Icon(Icons.check),
              ),
            ],
          ),
          visualDensity: VisualDensity.compact,
          onTap: () {
            rotationWeek.value = rw;
            Navigator.pop(context);
          },
        );
      }),
    );
  }
}
