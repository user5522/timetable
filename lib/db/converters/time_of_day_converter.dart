import 'package:drift/drift.dart';
import 'package:flutter/material.dart';

class TimeOfDayConverter extends TypeConverter<TimeOfDay, String> {
  const TimeOfDayConverter();

  @override
  TimeOfDay fromSql(String fromDb) {
    // Parse TimeOfDay from String
    return TimeOfDay(
      hour: int.parse(fromDb.split(':')[0].replaceAll("TimeOfDay(", "")),
      minute: int.parse(fromDb.split(':')[1].replaceAll(")", "")),
    );
  }

  @override
  String toSql(TimeOfDay value) {
    // Convert TimeOfDay to String
    return value.toString();
  }
}
