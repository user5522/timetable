import 'package:drift/drift.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart' as material;
import 'package:timetable/core/db/connection/native.dart';
import 'package:timetable/core/constants/rotation_weeks.dart';
import 'package:timetable/core/constants/days.dart';
import 'package:timetable/core/converters/converters.dart';
import 'package:timetable/core/db/tables/timetable.dart';
import 'package:timetable/core/db/tables/subject.dart';
import 'package:timetable/core/extensions/color.dart';

part 'database.g.dart';

/// manages the application's database connection and schema.
///
/// tables: Timetable, Subject
/// this handles:
/// - database initialization
/// - schema migrations
/// - table definitions
/// - database provider setup
///
/// migration strategy:
/// - v1 -> v2: Color storage format change
/// - v2 -> v3: Added timetable name and subject timetable columns
@DriftDatabase(tables: [Timetable, Subject])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(openConnection());

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      beforeOpen: (details) async {
        await customStatement('PRAGMA journal_mode=WAL');
      },
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
        if (from < 3) {
          await m.addColumn(timetable, timetable.name);
          await m.addColumn(subject, subject.timetable);
        }
      },
    );
  }

  static final StateProvider<AppDatabase> databaseProvider =
      StateProvider((ref) {
    final database = AppDatabase();
    ref.onDispose(database.close);

    return database;
  });
}
