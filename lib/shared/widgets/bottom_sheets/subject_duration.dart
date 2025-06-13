import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:timetable/shared/widgets/bottom_sheets/subject_data.dart';
import 'package:timetable/core/constants/durations.dart';

/// Bottom Sheet Modal Widget used to select the default subject duration.
class SubjectDurationModalBottomSheet extends StatelessWidget {
  final ValueNotifier<Duration> duration;

  const SubjectDurationModalBottomSheet({
    super.key,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    return SubjectDataBottomSheet(
      title: "choose_duration".tr(),
      children: List.generate(
        durations.length,
        (i) {
          final d = durations[i];
          bool isSelected = (d == duration.value);

          return ListTile(
            title: Row(
              children: [
                // writing minutes directly here will only work for now lol
                Text("${durations[i].inMinutes} minutes").tr(),
                const Spacer(),
                Visibility(
                  visible: isSelected,
                  child: const Icon(Icons.check),
                ),
              ],
            ),
            visualDensity: VisualDensity.compact,
            onTap: () {
              duration.value = d;
              Navigator.pop(context);
            },
          );
        },
      ),
    );
  }
}
