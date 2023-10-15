import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:timetable/constants/grid_properties.dart';
import 'package:timetable/constants/time.dart';
import 'package:timetable/models/settings.dart';

/// Widget that appears at the left side of the timetable grid view screen and shows the timetable time period.
class TimeColumn extends ConsumerWidget {
  const TimeColumn({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final compactMode = ref.watch(settingsProvider).compactMode;
    final customTimePeriod = ref.watch(settingsProvider).customTimePeriod;
    final customStartTime = ref.watch(settingsProvider).customStartTime;
    final is24HoursFormat = MediaQuery.of(context).alwaysUse24HourFormat;

    return Column(children: [
      Column(
        children: List.generate(
          rows(ref),
          (i) => SizedBox(
            height: compactMode ? 125 : 100,
            width: timeColumnWidth,
            child: Text(
              is24HoursFormat
                  ? times24h[i +
                      (customStartTime.hour == 0
                          ? 0
                          : customTimePeriod
                              ? customStartTime.hour
                              : 8)]
                  : timespmam[i +
                      (customStartTime.hour == 0
                          ? 0
                          : customTimePeriod
                              ? customStartTime.hour
                              : 8)],
              style: const TextStyle(fontSize: 13),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    ]);
  }
}
