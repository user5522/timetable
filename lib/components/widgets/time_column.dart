import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:timetable/constants/grid_properties.dart';
import 'package:timetable/constants/time.dart';
import 'package:timetable/provider/settings.dart';

/// Widget that appears at the left side of the timetable grid view screen and shows the timetable time period.
class TimeColumn extends ConsumerWidget {
  const TimeColumn({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final compactMode = ref.watch(settingsProvider).compactMode;
    final customTimePeriod = ref.watch(settingsProvider).customTimePeriod;
    final customStartTime = ref.watch(settingsProvider).customStartTime;
    final twentyFourHours = ref.watch(settingsProvider).twentyFourHours;
    final is24HoursFormat = MediaQuery.of(context).alwaysUse24HourFormat;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3.0),
      child: Column(
        children: List.generate(
          rows(ref),
          (i) {
            return SizedBox(
              height: compactMode ? 125 : 100,
              child: Text(
                is24HoursFormat
                    ? times24h[i +
                        (twentyFourHours
                            ? 0
                            : customTimePeriod
                                ? customStartTime.hour
                                : 8)]
                    : timespmam[i +
                        (twentyFourHours
                            ? 0
                            : customTimePeriod
                                ? customStartTime.hour
                                : 8)],
                style: const TextStyle(fontSize: 13),
                textAlign: TextAlign.center,
              ),
            );
          },
        ),
      ),
    );
  }
}
