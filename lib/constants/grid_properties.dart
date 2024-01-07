import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:timetable/provider/settings.dart';

/// Width of the time column.
const double timeColumnWidth = 22.5;

/// Number of columns in the grid view of the timetable.
int columns(WidgetRef ref) {
  final hideSunday = ref.watch(settingsProvider).hideSunday;

  if (hideSunday) {
    return 6;
  } else {
    return 7;
  }
}

/// Number of rows in the grid view based on the custom start time and custom end time (if customTimePeriod is true),
/// otherwise uses the default time period. (8:00 -> 18:00)
/// if hour difference is 0, there will be 24 rows
int rows(WidgetRef ref) {
  final customTimePeriod = ref.watch(settingsProvider).customTimePeriod;
  final customStartTime = ref.watch(settingsProvider).customStartTime;
  final customEndTime = ref.watch(settingsProvider).customEndTime;
  final twentyFourHours = ref.watch(settingsProvider).twentyFourHours;

  if (customTimePeriod && ((customEndTime.hour - customStartTime.hour) != 0)) {
    return (customEndTime.hour - customStartTime.hour).abs();
  }
  if (customTimePeriod &&
      (customStartTime.hour == 0 &&
          customStartTime.hour == customEndTime.hour)) {
    return 24;
  }
  if (twentyFourHours) return 24;

  return 10;
}
