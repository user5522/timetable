import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:non_uniform_border/non_uniform_border.dart';
import 'package:timetable/constants/grid_properties.dart';
import 'package:timetable/components/subject_management/subject_screen.dart';
import 'package:timetable/db/database.dart';

/// Subject container tile builder.
/// (the one you click on to create a Subject in the grid view.)
class SubjectContainerBuilder extends ConsumerWidget {
  final int rowIndex;
  final int columnIndex;
  final ValueNotifier<TimetableData> currentTimetable;

  const SubjectContainerBuilder({
    super.key,
    required this.rowIndex,
    required this.columnIndex,
    required this.currentTimetable,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shape = NonUniformBorder(
      leftWidth: columnIndex == 0 ? 0 : 1,
      rightWidth: columnIndex == (columns(ref) - 1) ? 0 : 1,
      topWidth: rowIndex == 0 ? 0 : 1,
      bottomWidth: rowIndex == (rows(ref) - 1) ? 0 : 1,
      strokeAlign: BorderSide.strokeAlignCenter,
      color: Colors.grey,
    );

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SubjectScreen(
              rowIndex: rowIndex,
              columnIndex: columnIndex,
              currentTimetable: currentTimetable,
            ),
          ),
        );
      },
      child: Container(
        decoration: ShapeDecoration(
          shape: shape,
        ),
        child: Align(
          child: Container(
            height: 1,
            color: const Color(0xFFB4B8AB).withOpacity(0.5),
          ),
        ),
        // child: Column(
        //   children: [
        //     Text("X: $columnIndex"),
        //     Text("Y: $rowIndex"),
        //   ],
        // ),
        // this is used for debugging (sometimes)
      ),
    );
  }
}
