import 'package:flutter/material.dart';
import 'package:timetable/components/widgets/bottom_sheets/rotation_week_modal_bottom_sheet.dart';
import 'package:timetable/constants/rotation_weeks.dart';
import 'package:timetable/helpers/rotation_weeks.dart';

/// Rotation Week config part of the Subject creation screen.
class RotationWeekConfig extends StatelessWidget {
  final ValueNotifier<RotationWeeks> rotationWeek;

  const RotationWeekConfig({
    super.key,
    required this.rotationWeek,
  });

  static const List<RotationWeeks> rotationWeeks = RotationWeeks.values;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text("Rotation Week"),
        const Spacer(),
        ActionChip(
          side: BorderSide.none,
          backgroundColor: const Color(0xffbabcbe),
          onPressed: () {
            showModalBottomSheet(
              showDragHandle: true,
              enableDrag: true,
              isDismissible: true,
              context: context,
              builder: (context) {
                return RotationWeekModalBottomSheet(
                  rotationWeek: rotationWeek,
                  rotationWeeks: rotationWeeks,
                );
              },
            );
          },
          label: Text(
            getRotationWeekLabel(rotationWeek.value),
            style: const TextStyle(
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}
