import 'package:drift/drift.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:timetable/db/database.dart';
import 'package:timetable/provider/overlapping_subjects.dart';

/// Subjects' [StateNotifier]
class SubjectNotifier extends StateNotifier<List<SubjectData>> {
  AppDatabase db;
  OverlappingSubjects overlappingSubjectsNotifier;

  SubjectNotifier(
    this.db,
    this.overlappingSubjectsNotifier,
  ) : super([]) {
    getSubjects();
  }

  /// returns the list of [SubjectData] from the database ([$SubjectTable])
  Future<List<SubjectData>> getSubjects() async {
    final subjects = await db.subject.select().get();
    state = subjects;
    return subjects;
  }

  /// adds a subject ([SubjectCompanion]) to the database ([$SubjectTable])
  // i use [SubjectData] in the SCS so i have to convert it everytime
  Future addSubject(SubjectCompanion entry) async {
    db.subject.insertOne(
      SubjectCompanion.insert(
        label: entry.label.value,
        location: entry.location,
        note: entry.note,
        color: entry.color.value,
        rotationWeek: entry.rotationWeek.value,
        day: entry.day.value,
        startTime: entry.startTime.value,
        endTime: entry.endTime.value,
        timetable: entry.timetable.value,
      ),
    );

    state = await getSubjects();
  }

  /// updates an already existing [SubjectData]
  ///
  /// also resets the overlapping subjects notifier
  /// so it refetches new data, otherwise there will be new
  /// and old data at the same time
  Future updateSubject(SubjectData entry) async {
    db.subject.update().replace(entry);
    state = await getSubjects();

    overlappingSubjectsNotifier.reset();
  }

  /// deletes a [SubjectData] from db ([$SubjectTable])
  Future deleteSubject(SubjectData entry) async {
    db.subject.deleteWhere((t) => t.id.equals(entry.id));
    state = await getSubjects();

    overlappingSubjectsNotifier.reset();
  }

  /// executed from the [TimetableNotifier] to delete all the subjects
  /// in the deleted timetable to avoid errors
  Future deleteTimetableSubjects(
    List<TimetableData> timetables,
    TimetableData timetable,
  ) async {
    var subjects = await db.subject.select().get();

    for (var subject in subjects.where(
      (e) => e.timetable == timetable.name,
    )) {
      db.subject.deleteWhere(
        (t) => t.id.equals(subject.id),
      );
    }

    state = await getSubjects();
  }

  /// deletes all subjects from db ([$SubjectTable]) and state
  ///
  /// also resets the overlapping subjects notifier.
  Future<void> resetData() async {
    await db.delete($SubjectTable(db)).go();
    state = [];

    overlappingSubjectsNotifier.reset();
  }
}

final subjectProvider =
    StateNotifierProvider<SubjectNotifier, List<SubjectData>>(
  (ref) => SubjectNotifier(
    ref.watch(AppDatabase.databaseProvider),
    ref.watch(overlappingSubjectsProvider.notifier),
  ),
);
