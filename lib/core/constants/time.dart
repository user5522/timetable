import 'package:flutter/material.dart';

/// Returns a list of formatted times based on user preferences
List<String> getFormattedTimes(bool use24Hour) {
  return List.generate(24, (hour) {
    if (use24Hour) {
      return hour.toString().padLeft(2, '0');
    } else {
      final period = hour < 12 ? 'AM' : 'PM';
      final displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
      return '$displayHour\n$period';
    }
  });
}

/// This function returns a string representation of the time based on the index,
/// the format of the time (24 hour or 12 hour), the time period (custom or default),
/// the custom start time, and the custom end time.
String getTimeString(
  int index,
  bool is24HoursFormat,
  bool twentyFourHours,
  bool customTimePeriod,
  TimeOfDay customStartTime,
) {
  final int customTimePeriodStartHour =
      customTimePeriod ? customStartTime.hour : 8;
  final int startHour = twentyFourHours ? 0 : customTimePeriodStartHour;
  final int timeIndex = index + startHour;

  final times = getFormattedTimes(is24HoursFormat);

  return times[timeIndex];
}
