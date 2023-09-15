import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:timetable/constants/grid_properties.dart';
import 'package:timetable/models/settings.dart';
import 'package:timetable/utilities/grid_utils.dart';

class DaysRow extends ConsumerWidget {
  const DaysRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final compactMode = ref.watch(settingsProvider).compactMode;
    final singleLetterDays = ref.watch(settingsProvider).singleLetterDays;
    double screenWidth = MediaQuery.of(context).size.width;

    return Row(
      children: List.generate(
        days.length,
        (i) => Container(
          alignment: Alignment.bottomCenter,
          height: 20,
          width: compactMode
              ? (screenWidth / columns - ((timeColumnWidth + 10) / 10))
              : 100,
          child: Text(
            singleLetterDays
                ? days[i][0]
                : compactMode
                    ? days[i].substring(0, 3)
                    : days[i],
          ),
        ),
      ),
    );
  }
}
