import 'package:drift/drift.dart';

class Timetable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
}
