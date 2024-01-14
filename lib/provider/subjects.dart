import 'package:drift/drift.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:timetable/db/database.dart';
import 'package:timetable/provider/overlapping_subjects.dart';

class SubjectNotifier extends StateNotifier<List<SubjectData>> {
  AppDatabase db;
  OverlappingSubjects overlappingSubjectsNotifier;

  SubjectNotifier(
    this.db,
    this.overlappingSubjectsNotifier,
  ) : super([]) {
    getSubjects();
  }

  Future<List<SubjectData>> getSubjects() async {
    final subjects = await db.subject.select().get();
    state = subjects;
    return subjects;
  }

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

  Future updateSubject(SubjectData entry) async {
    db.subject.update().replace(entry);
    state = await getSubjects();

    overlappingSubjectsNotifier.reset();
  }

  Future deleteSubject(SubjectData entry) async {
    db.subject.deleteWhere((t) => t.id.equals(entry.id));
    state = await getSubjects();

    overlappingSubjectsNotifier.reset();
  }

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

  void resetData() {
    db.subject.delete();
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
