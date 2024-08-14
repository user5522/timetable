import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:timetable/provider/settings.dart';

/// Returns the custom start time set by the user if customTimePeriod is true,
/// otherwise returns the default start time. (8:00)
TimeOfDay getCustomStartTime(TimeOfDay customTime, WidgetRef ref) {
  final customTimePeriod = ref.watch(settingsProvider).customTimePeriod;
  final twentyFourHours = ref.watch(settingsProvider).twentyFourHours;

  if (customTimePeriod) return customTime;
  if (twentyFourHours) return const TimeOfDay(hour: 0, minute: 0);

  return const TimeOfDay(hour: 8, minute: 0);
}

/// Returns the custom end time set by the user if customTimePeriod is true,
/// otherwise returns the default end time. (18:00)
TimeOfDay getCustomEndTime(TimeOfDay customTime, WidgetRef ref) {
  final customTimePeriod = ref.watch(settingsProvider).customTimePeriod;
  final twentyFourHours = ref.watch(settingsProvider).twentyFourHours;

  if (customTimePeriod) return customTime;
  if (twentyFourHours) return const TimeOfDay(hour: 0, minute: 0);

  return const TimeOfDay(hour: 18, minute: 0);
}

/// Returns a formatted custom time hour.
String getCustomTimeHour(TimeOfDay customTime) {
  if (customTime.hour < 10) return "0${customTime.hour}";
  return "${customTime.hour}";
}

/// Returns a formatted custom time hour.
String getCustomTimeMinute(TimeOfDay customTime) {
  if (customTime.minute < 10) return "0${customTime.minute}";
  return "${customTime.minute}";
}
