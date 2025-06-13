import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:timetable/shared/widgets/act_chip.dart';
import 'package:timetable/shared/widgets/bottom_sheets/timetables_modal.dart';
import 'package:timetable/core/db/database.dart';

/// Timetable configuration part of the Subject creation screen.
class TimetableConfig extends StatelessWidget {
  final ValueNotifier<Timetable?> timetable;

  const TimetableConfig({
    super.key,
    required this.timetable,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text("timetable").plural(1),
        const Spacer(),
        ActChip(
          onPressed: () {
            showModalBottomSheet(
              showDragHandle: true,
              enableDrag: true,
              isDismissible: true,
              isScrollControlled: true,
              context: context,
              builder: (context) {
                return Wrap(
                  children: [TimetablesModalBottomSheet(timetable: timetable)],
                );
              },
            );
          },
          label: Text(timetable.value!.name),
        ),
      ],
    );
  }
}
