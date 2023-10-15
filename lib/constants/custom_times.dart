import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:timetable/models/settings.dart';

/// Returns the custom start time set by the user if customTimePeriod is true,
/// otherwise returns the default start time. (8:00)
TimeOfDay getCustomStartTime(TimeOfDay customTime, WidgetRef ref) {
  final customTimePeriod = ref.watch(settingsProvider).customTimePeriod;

  if (customTimePeriod) {
    if (customTime.hour != 00) {
      return TimeOfDay(hour: customTime.hour, minute: customTime.minute);
    } else {
      return const TimeOfDay(hour: 0, minute: 0);
    }
  } else {
    return const TimeOfDay(hour: 8, minute: 0);
  }
}

/// Returns the custom end time set by the user if customTimePeriod is true,
/// otherwise returns the default end time. (18:00)
TimeOfDay getCustomEndTime(TimeOfDay customTime, WidgetRef ref) {
  final customTimePeriod = ref.watch(settingsProvider).customTimePeriod;

  if (customTimePeriod) {
    if (customTime.hour != 00) {
      return TimeOfDay(hour: customTime.hour, minute: customTime.minute);
    } else {
      return const TimeOfDay(hour: 24, minute: 0);
    }
  } else {
    return const TimeOfDay(hour: 18, minute: 0);
  }
}

/// Returns the hour part of the customTime, formatted.
String getCustomTimeHour(TimeOfDay customTime) {
  if (customTime.hour < 10) {
    return "0${customTime.hour}";
  } else {
    return "${customTime.hour}";
  }
}

/// Returns the minute part of the customTime, formatted.
String getCustomTimeMinute(TimeOfDay customTime) {
  if (customTime.minute < 10) {
    return "0${customTime.minute}";
  } else {
    return "${customTime.minute}";
  }
}
