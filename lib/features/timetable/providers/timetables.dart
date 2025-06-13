import 'dart:async';

import 'package:drift/drift.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:timetable/core/db/database.dart';
import 'package:timetable/features/subjects/providers/subjects.dart';

/// Timetable state management
/// multiple timetable support, manages timetable CRUD operations
/// and default timetable handling
class TimetableNotifier extends StateNotifier<List<Timetable>> {
  final AppDatabase db;
  final SubjectNotifier subjectsNotifier;

  late final StreamSubscription<List<Timetable>> _timetablesSubscription;

  TimetableNotifier(this.db, this.subjectsNotifier) : super([]) {
    _timetablesSubscription =
        db.timetables.select().watch().listen((timetables) async {
      if (timetables.isEmpty) {
        // If the table somehow becomes empty we ensure a default timetable exists by
        // calling resetData.
        await resetData();
      } else {
        state = timetables;
      }
    });

    // checkAndLoadInitialData();
  }

  // Future<void> checkAndLoadInitialData() async {
  //   final currentTimetables = await db.timetables.select().get();
  //   if (currentTimetables.isEmpty) {
  //     await resetData();
  //   }
  // }

  @override
  void dispose() {
    _timetablesSubscription.cancel();
    super.dispose();
  }

  /// returns the list of timetables from notifier
  List<Timetable> get timetables => state;

  /// returns the list of timetables from database
  Future<List<Timetable>> fetchTimetablesFromDatabase() async {
    return db.timetables.select().get();
  }

  /// adds a [TimetablesCompanion] to db ([$TimetablesTable])
  Future addTimetable(TimetablesCompanion entry) async {
    db.timetables.insertOne(
      TimetablesCompanion.insert(
        name: entry.name.value,
      ),
    );
  }

  /// updates preexisting timetables
  // i don't think this ever gets used (yet)
  Future updateTimetable(Timetable entry) async {
    db.timetables.update().replace(entry);
  }

  /// deletes timetable from db
  Future deleteTimetable(Timetable entry) async {
    db.timetables.deleteWhere((t) => t.id.equals(entry.id));
    subjectsNotifier.deleteTimetableSubjects(state, entry);
  }

  /// resets the database ([$TimetableTable]) to its initial state
  ///
  /// also automatically adds an initial timetable to avoid errors
  Future<void> resetData() async {
    final allTimetablesInDb = await db.timetables.select().get();
    for (var timetable in allTimetablesInDb) {
      subjectsNotifier.deleteTimetableSubjects([timetable], timetable);
    }

    await db.timetables.deleteAll();
    await db.timetables.insertOne(TimetablesCompanion.insert(name: "1"));
  }
}

final timetableProvider =
    StateNotifierProvider<TimetableNotifier, List<Timetable>>(
  (ref) => TimetableNotifier(
    ref.watch(AppDatabase.databaseProvider),
    ref.watch(subjectProvider.notifier),
  ),
);
