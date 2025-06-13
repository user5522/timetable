import 'package:drift/drift.dart';

/// Timetable table definition and data model
class Timetable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
}
