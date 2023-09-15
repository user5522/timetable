import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:timetable/models/settings.dart';

const double timeColumnWidth = 22.5;
const int columns = 7;

int rows(WidgetRef ref) {
  final customTimePeriod = ref.watch(settingsProvider).customTimePeriod;
  final customStartTime = ref.watch(settingsProvider).customStartTime;
  final customEndTime = ref.watch(settingsProvider).customEndTime;

  if (customTimePeriod && (customEndTime.hour - customStartTime.hour != 0)) {
    return (customEndTime.hour - customStartTime.hour).abs();
  } else if (customTimePeriod &&
      (customEndTime.minute - customStartTime.minute == 0)) {
    return 23;
  } else {
    return 10;
  }
}
