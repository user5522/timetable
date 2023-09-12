import 'package:flutter/material.dart';
import 'package:non_uniform_border/non_uniform_border.dart';
import 'package:timetable/screens/cell_screen.dart';
import 'package:timetable/screens/timetable_screen.dart';

class SubjectContainerBuilder extends StatelessWidget {
  final int rowIndex;
  final int columnIndex;

  const SubjectContainerBuilder({
    super.key,
    required this.rowIndex,
    required this.columnIndex,
  });

  @override
  Widget build(BuildContext context) {
    final shape = NonUniformBorder(
      leftWidth: columnIndex == 0 ? 0 : 1,
      rightWidth: columnIndex == (columns - 1) ? 0 : 1,
      topWidth: rowIndex == 0 ? 0 : 1,
      bottomWidth: rowIndex == (rows - 1) ? 0 : 1,
      strokeAlign: BorderSide.strokeAlignCenter,
      color: Colors.grey,
    );

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            settings: const RouteSettings(
              name: "CellScreen",
            ),
            builder: (context) => CellScreen(
              rowIndex: rowIndex,
              columnIndex: columnIndex,
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
            width: 100,
            height: 1,
            color: const Color(0xFFB4B8AB).withOpacity(0.5),
          ),
        ),
        // child: Column(
        //   children: [
        //     Text("X: $rowIndex"),
        //     Text("Y: $columnIndex"),
        //   ],
        // ),
      ),
    );
  }
}