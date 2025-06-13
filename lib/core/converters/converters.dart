import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:timetable/core/extensions/color.dart';

class ColorConverter extends TypeConverter<Color, int> {
  const ColorConverter();

  @override
  Color fromSql(int fromDb) {
    // Parse Color from int
    return Color(fromDb);
  }

  @override
  int toSql(Color value) {
    // get Color value (int)
    return value.toInt();
  }
}

class TimeOfDayConverter extends TypeConverter<TimeOfDay, String> {
  const TimeOfDayConverter();

  @override
  TimeOfDay fromSql(String fromDb) {
    String timeOnly = fromDb.substring(10, fromDb.length - 1);

    List<String> parts = timeOnly.split(":");
    int hour = int.parse(parts[0]);
    int minute = int.parse(parts[1]);

    TimeOfDay timeOfDay = TimeOfDay(hour: hour, minute: minute);

    return timeOfDay;
  }

  @override
  String toSql(TimeOfDay value) {
    // Convert TimeOfDay to String
    return "TimeOfDay(${value.hour}:${value.minute})";
  }
}
