import 'package:drift/drift.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:timetable/db/database.dart';
import 'package:timetable/provider/subjects.dart';

class TimetableNotifier extends StateNotifier<List<TimetableData>> {
  AppDatabase db;
  SubjectNotifier subjectsNotifier;

  TimetableNotifier(
    this.db,
    this.subjectsNotifier,
  ) : super([]) {
    loadTimetables();
  }

  Future loadTimetables() async {
    final timetables = await db.timetable.select().get();
    if (timetables.isEmpty) await resetData();
    state = timetables;
  }

  Future<List<TimetableData>> getTimetables() async {
    final timetables = await db.timetable.select().get();
    if (timetables.isEmpty) await resetData();
    return timetables;
  }

  Future addTimetable(TimetableCompanion entry) async {
    db.timetable.insertOne(
      TimetableCompanion.insert(
        name: entry.name.value,
      ),
    );

    state = await getTimetables();
  }

  Future updateTimetable(TimetableData entry) async {
    db.timetable.update().replace(entry);

    state = await getTimetables();
  }

  Future deleteTimetable(TimetableData entry) async {
    db.timetable.deleteWhere((t) => t.id.equals(entry.id));
    subjectsNotifier.deleteTimetableSubjects(state, entry);

    state = await getTimetables();
  }

  Future resetData() async {
    db.timetable.deleteAll();
    for (var timetable in state) {
      subjectsNotifier.deleteTimetableSubjects(state, timetable);
    }

    db.timetable.insertOne(TimetableCompanion.insert(name: "1"));
    state = await getTimetables();
  }
}

final timetableProvider =
    StateNotifierProvider<TimetableNotifier, List<TimetableData>>(
  (ref) => TimetableNotifier(
    ref.watch(AppDatabase.databaseProvider),
    ref.watch(subjectProvider.notifier),
  ),
);
