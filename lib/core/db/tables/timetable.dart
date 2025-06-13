import 'package:drift/drift.dart';

/// Timetable table definition and data model
// changed table name in v4 from Timetable to Timetables
class Timetables extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
}
