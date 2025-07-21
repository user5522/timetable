import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:timetable/core/constants/days.dart';
import 'package:timetable/core/services/day.dart';

final dayServiceProvider = Provider<DaysService>((ref) {
  return DaysService(ref);
});

final orderedDaysProvider = Provider<List<Day>>((ref) {
  return ref.watch(dayServiceProvider).orderedDays;
});

final currentDayIndexProvider = StateProvider<int>((ref) {
  return ref.watch(dayServiceProvider).currentDayIndex;
});
