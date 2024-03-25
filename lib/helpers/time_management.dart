import 'package:flutter/material.dart';

/// check if time 1 is before time2
bool isBefore(TimeOfDay time1, TimeOfDay time2) {
  return (time1.hour < time2.hour) ||
      (time1.hour == time2.hour && time1.minute < time2.minute);
}

/// check if time 1 is after time2
bool isAfter(TimeOfDay time1, TimeOfDay time2) {
  return (time1.hour > time2.hour) ||
      (time1.hour == time2.hour && time1.minute > time2.minute);
}
