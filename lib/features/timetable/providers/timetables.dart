import 'dart:async';

import 'package:drift/drift.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:timetable/core/db/database.dart';
import 'package:timetable/features/subjects/providers/subjects.dart';

/// Timetable state management
/// multiple timetable support, manages timetable CRUD operations
/// and default timetable handling
class TimetableNotifier extends StateNotifier<List<TimetableData>> {
  final AppDatabase db;
  final SubjectNotifier subjectsNotifier;

  late final StreamSubscription<List<TimetableData>> timetablesSubscription;

  TimetableNotifier(this.db, this.subjectsNotifier) : super([]) {
    timetablesSubscription =
        db.timetable.select().watch().listen((timetables) async {
      if (timetables.isEmpty) {
        // If the table somehow becomes empty we ensure a default timetable exists by
        // calling resetData.
        await resetData();
      } else {
        state = timetables;
      }
    });

    checkAndLoadInitialData();
  }

  Future<void> checkAndLoadInitialData() async {
    final currentTimetables = await db.timetable.select().get();
    if (currentTimetables.isEmpty) {
      await resetData();
    }
  }

  @override
  void dispose() {
    timetablesSubscription.cancel();
    super.dispose();
  }

  /// returns the list of timetables from notifier
  List<TimetableData> get timetables => state;

  /// returns the list of timetables from database
  Future<List<TimetableData>> fetchTimetablesFromDatabase() async {
    return db.timetable.select().get();
  }

  /// adds a [TimetableCompanion] to db ([$TimetableTable])
  Future addTimetable(TimetableCompanion entry) async {
    db.timetable.insertOne(
      TimetableCompanion.insert(
        name: entry.name.value,
      ),
    );
  }

  /// updates preexisting timetables
  // i don't think this ever gets used (yet)
  Future updateTimetable(TimetableData entry) async {
    db.timetable.update().replace(entry);
  }

  /// deletes timetable from db
  Future deleteTimetable(TimetableData entry) async {
    db.timetable.deleteWhere((t) => t.id.equals(entry.id));
    subjectsNotifier.deleteTimetableSubjects(state, entry);
  }

  /// resets the database ([$TimetableTable]) to its initial state
  ///
  /// also automatically adds an initial timetable to avoid errors
  Future<void> resetData() async {
    final allTimetablesInDb = await db.timetable.select().get();
    for (var timetable in allTimetablesInDb) {
      subjectsNotifier.deleteTimetableSubjects([timetable], timetable);
    }

    await db.timetable.deleteAll();
    await db.timetable.insertOne(TimetableCompanion.insert(name: "1"));
  }
}

final timetableProvider =
    StateNotifierProvider<TimetableNotifier, List<TimetableData>>(
  (ref) => TimetableNotifier(
    ref.watch(AppDatabase.databaseProvider),
    ref.watch(subjectProvider.notifier),
  ),
);
