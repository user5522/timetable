import 'package:flutter/material.dart';

class TimeFormatter {
  static String getTime(TimeOfDay time, bool uses24HoursFormat) {
    final minute = time.minute.toString().padLeft(2, '0');
    if (uses24HoursFormat) {
      final hour = time.hour.toString().padLeft(2, '0');
      return "$hour:$minute";
    }

    final hour =
        time.hour == 0 ? 12 : (time.hour > 12 ? time.hour - 12 : time.hour);
    final period = time.hour >= 12 ? "PM" : "AM";
    final formattedHour = hour.toString().padLeft(2, '0');
    return "$formattedHour:$minute $period";
  }

  static String getTimeNoPadding(TimeOfDay time, bool uses24HoursFormat) {
    final minute = time.minute.toString().padLeft(2, '0');
    if (uses24HoursFormat) return "${time.hour}:$minute";

    final hour =
        time.hour == 0 ? 12 : (time.hour > 12 ? time.hour - 12 : time.hour);
    final period = time.hour >= 12 ? "PM" : "AM";
    return "$hour:$minute $period";
  }

  static ({String hour, String minute}) getTimeComponents(TimeOfDay time) {
    return (
      hour: time.hour.toString().padLeft(2, '0'),
      minute: time.minute.toString().padLeft(2, '0')
    );
  }
}
