import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:timetable/constants/days.dart';
import 'package:timetable/constants/grid_properties.dart';
import 'package:timetable/provider/settings.dart';

/// Widget that appears at the top of the timetable grid view screen and shows the week's days.
class DaysRow extends ConsumerWidget {
  const DaysRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final compactMode = ref.watch(settingsProvider).compactMode;
    final singleLetterDays = ref.watch(settingsProvider).singleLetterDays;
    final hideSunday = ref.watch(settingsProvider).hideSunday;

    double screenWidth = MediaQuery.of(context).size.width;
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    double tileWidth = compactMode
        ? (screenWidth / columns(ref) - ((timeColumnWidth + 10) / 10))
        : isPortrait
            ? 100
            : (screenWidth / columns(ref) - ((timeColumnWidth + 10) / 10));

    return Row(
      children: List.generate(
        hideSunday ? days.length - 1 : days.length,
        (i) => Container(
          alignment: Alignment.bottomCenter,
          width: tileWidth,
          child: Text(
            singleLetterDays
                ? days[i][0]
                : isPortrait && compactMode
                    ? days[i].substring(0, 3)
                    : days[i],
          ),
        ),
      ),
    );
  }
}
