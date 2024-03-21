import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:timetable/components/widgets/subject_data_bottom_sheet.dart';
import 'package:timetable/constants/days.dart';

/// Bottom Sheet Modal Widget used to select a subject's day.
class DaysModalBottomSheet extends StatelessWidget {
  final List<Days> daysList;
  final ValueNotifier<Days> day;

  const DaysModalBottomSheet({
    super.key,
    required this.daysList,
    required this.day,
  });

  @override
  Widget build(BuildContext context) {
    return SubjectDataBottomSheet(
      title: "week_days".tr(),
      children: daysList.map(
        (d) {
          bool isSelected = (d == day.value);

          return ListTile(
            title: Row(
              children: [
                Text(
                  days[d.index],
                ).tr(),
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
