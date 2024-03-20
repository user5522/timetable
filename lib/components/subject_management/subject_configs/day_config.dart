import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:timetable/components/widgets/act_chip.dart';
import 'package:timetable/components/widgets/bottom_sheets/days_modal_bottom_sheet.dart';
import 'package:timetable/constants/days.dart';

/// Day configuration part of the Subject creation screen.
class DayConfig extends StatelessWidget {
  final ValueNotifier<Days> day;

  const DayConfig({
    super.key,
    required this.day,
  });

  static const List<Days> daysList = Days.values;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text("day").plural(1),
        const Spacer(),
        ActChip(
          onPressed: () {
            showModalBottomSheet(
              showDragHandle: true,
              enableDrag: true,
              isDismissible: true,
              context: context,
              builder: (context) {
                return Wrap(
                  children: [
                    DaysModalBottomSheet(
                      daysList: daysList,
                      day: day,
                    ),
                  ],
                );
              },
            );
          },
          label: Text(
            days[day.value.index],
          ),
        ),
      ],
    );
  }
}
