import 'package:drift/drift.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:timetable/db/database.dart';
import 'package:timetable/models/overlapping_subjects.dart';

class SubjNotifier extends StateNotifier<List<SubjectData>> {
  AppDatabase db;
  List<List<SubjectData>> overlappingSubjects;

  SubjNotifier(
    this.db,
    this.overlappingSubjects,
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
      ),
    );

    state = await getSubjects();
  }

  Future updateSubject(SubjectData entry) async {
    db.subject.update().replace(entry);

    state = await getSubjects();
  }

  Future deleteSubject(SubjectData entry) async {
    db.subject.deleteWhere((t) => t.id.equals(entry.id));
    overlappingSubjects.removeWhere((e) => e.contains(entry));

    state = await getSubjects();
  }

  void resetData() {
    db.subject.delete();

    state = [];
  }
}

final subjProvider = StateNotifierProvider<SubjNotifier, List<SubjectData>>(
  (ref) => SubjNotifier(
      ref.watch(AppDatabase.provider), ref.watch(overlappingSubjectsProvider)),
);
