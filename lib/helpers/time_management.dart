import 'package:flutter/material.dart';

bool isBefore(TimeOfDay time1, TimeOfDay time2) {
  return (time1.hour < time2.hour) ||
      (time1.hour == time2.hour && time1.minute < time2.minute);
}

bool isAfter(TimeOfDay time1, TimeOfDay time2) {
  return (time1.hour > time2.hour) ||
      (time1.hour == time2.hour && time1.minute > time2.minute);
}
