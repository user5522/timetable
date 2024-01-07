import 'package:flutter/material.dart';
import 'package:timetable/components/widgets/bottom_sheets/timetables_modal_bottom_sheet.dart';
import 'package:timetable/db/database.dart';

/// Timetable config part of the Subject creation screen.
class TimetableConfig extends StatelessWidget {
  final ValueNotifier<TimetableData?> timetable;

  const TimetableConfig({
    super.key,
    required this.timetable,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text("Timetable"),
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
                return Wrap(
                  children: [
                    TimetablesModalBottomSheet(
                      timetable: timetable,
                    ),
                  ],
                );
              },
            );
          },
          label: Text(
            timetable.value!.name,
            style: const TextStyle(
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}
