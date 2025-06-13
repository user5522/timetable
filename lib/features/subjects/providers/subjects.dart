import 'dart:async';

import 'package:drift/drift.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:timetable/core/db/database.dart';
import 'package:timetable/features/subjects/providers/overlapping_subjects.dart';

/// Subject state management
/// manages CRUD operations for subjects, handles subject filtering and state updates
/// also manages subject-timetable relationships
class SubjectNotifier extends StateNotifier<List<Subject>> {
  final AppDatabase db;
  final OverlappingSubjects overlappingSubjectsNotifier;

  late StreamSubscription _subscription;

  SubjectNotifier(this.db, this.overlappingSubjectsNotifier) : super([]) {
    _subscription = db.subjects.select().watch().listen((subjects) {
      state = subjects;
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  Future fetchSubjectsFromDatabase() async {
    await db.subjects.select().get();
  }

  /// adds a subject ([SubjectsCompanion]) to the database ([$SubjectsTable])
  Future addSubject(SubjectsCompanion entry) async {
    await db.subjects.insertOne(entry);
  }

  /// updates an already existing [Subject]
  ///
  /// also resets the overlapping subjects notifier
  /// so it refetches new data, otherwise there will be new
  /// and old data at the same time
  Future updateSubject(SubjectsCompanion entry) async {
    await db.subjects.update().replace(entry);

    overlappingSubjectsNotifier.reset();
  }

  /// deletes a [Subject] from db ([$SubjectsTable])
  Future deleteSubject(Subject entry) async {
    await db.subjects.deleteWhere((t) => t.id.equals(entry.id));

    overlappingSubjectsNotifier.reset();
  }

  /// executed from the [TimetableNotifier] to delete all the subjects
  /// in the deleted timetable to avoid errors
  Future deleteTimetableSubjects(
    List<Timetable> timetables,
    Timetable timetable,
  ) async {
    var subjects = await db.subjects.select().get();

    for (var subject in subjects.where((e) => e.timetable == timetable.name)) {
      await db.subjects.deleteWhere((t) => t.id.equals(subject.id));
    }
  }

  /// deletes [$SubjectsTable] and resets overlapping subjects and state.
  Future<void> resetData() async {
    await db.delete($SubjectsTable(db)).go();
    state = [];

    overlappingSubjectsNotifier.reset();
  }
}

final subjectProvider = StateNotifierProvider<SubjectNotifier, List<Subject>>(
  (ref) => SubjectNotifier(
    ref.watch(AppDatabase.databaseProvider),
    ref.watch(overlappingSubjectsProvider.notifier),
  ),
);
