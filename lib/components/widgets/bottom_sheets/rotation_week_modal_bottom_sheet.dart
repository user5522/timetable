import 'package:flutter/material.dart';
import 'package:timetable/constants/rotation_weeks.dart';

class RotationWeekModalBottomSheet extends StatelessWidget {
  final List<RotationWeeks> rotationWeeks;
  final ValueNotifier<RotationWeeks> rotationWeek;

  const RotationWeekModalBottomSheet(
      {super.key, required this.rotationWeeks, required this.rotationWeek});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
          child: Text(
            "Rotation Weeks",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        ListView(
          shrinkWrap: true,
          primary: false,
          children: rotationWeeks.where((e) => e != RotationWeeks.all).map(
            (e) {
              return ListTile(
                title: Text(
                  getRotationWeekLabel(e),
                ),
                visualDensity: VisualDensity.compact,
                onTap: () {
                  rotationWeek.value = e;
                  Navigator.pop(context);
                },
              );
            },
          ).toList(),
        ),
      ],
    );
  }
}
