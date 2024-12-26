import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:timetable/extensions/color.dart';

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
