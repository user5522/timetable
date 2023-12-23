import 'package:drift/drift.dart';
import 'package:timetable/constants/days.dart';
import 'package:timetable/constants/rotation_weeks.dart';
import 'package:timetable/db/converters/color_converter.dart';
import 'package:timetable/db/converters/time_of_day_converter.dart';

class Subject extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get label => text()();
  TextColumn get location => text().nullable()();
  TextColumn get note => text().nullable()();
  // changed in v2 so it uses the ColorConverter
  // to maintain the Color type instead of using int.
  IntColumn get color => integer().map(const ColorConverter())();
  IntColumn get rotationWeek => intEnum<RotationWeeks>()();
  IntColumn get day => intEnum<Days>()();
  TextColumn get startTime => text().map(const TimeOfDayConverter())();
  TextColumn get endTime => text().map(const TimeOfDayConverter())();
}
