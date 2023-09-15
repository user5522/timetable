import 'package:flutter/material.dart';

TimeOfDay getCustomStartTime(TimeOfDay customTime) {
  if (customTime.hour != 00) {
    return TimeOfDay(hour: customTime.hour, minute: customTime.minute);
  } else {
    return const TimeOfDay(hour: 0, minute: 0);
  }
}

TimeOfDay getCustomEndTime(TimeOfDay customTime) {
  if (customTime.hour != 00) {
    return TimeOfDay(hour: customTime.hour, minute: customTime.minute);
  } else {
    return const TimeOfDay(hour: 24, minute: 0);
  }
}

String getCustomTimeHour(TimeOfDay customTime) {
  if (customTime.hour < 10) {
    return "0${customTime.hour}";
  } else {
    return "${customTime.hour}";
  }
}

String getCustomTimeMinute(TimeOfDay customTime) {
  if (customTime.minute < 10) {
    return "0${customTime.minute}";
  } else {
    return "${customTime.minute}";
  }
}
