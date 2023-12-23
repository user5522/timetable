import 'package:drift/drift.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:timetable/constants/rotation_weeks.dart';
import 'package:timetable/constants/days.dart';
import 'package:timetable/db/converters/color_converter.dart';
import 'package:timetable/db/models/subject.dart';
import 'package:timetable/db/connection/native.dart';
import 'package:timetable/db/converters/time_of_day_converter.dart';
import 'package:flutter/material.dart' as material;

part 'database.g.dart';

@DriftDatabase(tables: [Subject])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 2) {
          // colors changed in v2 so they use the ColorConverter
          // to maintain the Color type instead of using int in v1.
          await m.alterTable(
            TableMigration(
              subject,
              columnTransformer: {
                subject.color: subject.color,
              },
            ),
          );
        }
      },
    );
  }

  static final StateProvider<AppDatabase> provider = StateProvider((ref) {
    final database = AppDatabase();
    ref.onDispose(database.close);

    return database;
  });
}
