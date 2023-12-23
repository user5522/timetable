import 'package:drift/drift.dart';
import 'package:flutter/material.dart';

class ColorConverter extends TypeConverter<Color, int> {
  const ColorConverter();

  @override
  Color fromSql(int fromDb) {
    // Parse TimeOfDay from String
    return Color(fromDb);
  }

  @override
  int toSql(Color value) {
    // get Color value (int)
    return value.value;
  }
}
