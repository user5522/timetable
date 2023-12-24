import 'package:flutter/material.dart';
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
        ),
      ],
    );
  }
}
