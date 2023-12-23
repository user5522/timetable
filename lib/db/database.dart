import 'package:drift/drift.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:timetable/constants/rotation_weeks.dart';
import 'package:timetable/constants/days.dart';
import 'package:timetable/db/models.dart';
import 'package:timetable/db/connection/native.dart';
import 'package:timetable/db/converters/time_of_day_converter.dart';
import 'package:flutter/material.dart' as material;

part 'database.g.dart';

@DriftDatabase(tables: [Subject])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(openConnection());

  @override
  int get schemaVersion => 1;

  static final StateProvider<AppDatabase> provider = StateProvider((ref) {
    final database = AppDatabase();
    ref.onDispose(database.close);

    return database;
  });
}
