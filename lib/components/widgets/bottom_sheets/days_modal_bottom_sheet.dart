import 'package:flutter/material.dart';
import 'package:timetable/components/widgets/subject_data_bottom_sheet.dart';
import 'package:timetable/constants/days.dart';

/// Bottom Sheet Modal Widget used to select a subject's day.
class DaysModalBottomSheet extends StatelessWidget {
  final List<Days> days;
  final ValueNotifier<Days> day;

  const DaysModalBottomSheet({
    super.key,
    required this.days,
    required this.day,
  });

  @override
  Widget build(BuildContext context) {
    return SubjectDataBottomSheet(
      title: "Week days",
      children: days.map(
        (d) {
          bool isSelected = (d == day.value);

          return ListTile(
            title: Row(
              children: [
                Text(
                  d.name[0].toUpperCase() + d.name.substring(1).toLowerCase(),
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
              day.value = d;
              Navigator.pop(context);
            },
          );
        },
      ).toList(),
    );
  }
}
