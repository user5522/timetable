import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:timetable/core/constants/days.dart';
import 'package:timetable/features/settings/providers/settings.dart';

/// Service to provide the current day's index and ordered days.
class DaysService {
  const DaysService(this.ref);
  final Ref ref;

  List<Day> get orderedDays {
    final settings = ref.watch(settingsProvider);
    var days = Day.values;

    if (settings.hideSunday) {
      days = days.where((day) => day != Day.sunday).toList();
    }

    final rotatedDays = [
      ...days.sublist(settings.weekStartDay),
      ...days.sublist(0, settings.weekStartDay),
    ];

    return rotatedDays;
  }

  int get currentDayIndex {
    final settings = ref.watch(settingsProvider);
    final now = DateTime.now();
    final currentIsoWeekday = now.weekday;

    var dayIndex = currentIsoWeekday - 1;

    dayIndex = (dayIndex - settings.weekStartDay) % Day.values.length;
    if (dayIndex < 0) dayIndex += Day.values.length;

    if (settings.hideSunday) {
      if (currentIsoWeekday == 7) return -1;
      if (currentIsoWeekday > settings.weekStartDay) {
        dayIndex -= 1;
      }
    }

    return dayIndex;
  }
}
