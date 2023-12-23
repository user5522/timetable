import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:timetable/db/database.dart';

/// A [StateNotifier] that holds the list of overlapping subjects.
class OverlappingSubjects extends StateNotifier<List<List<SubjectData>>> {
  OverlappingSubjects() : super([]);
}

final overlappingSubjectsProvider =
    StateNotifierProvider<OverlappingSubjects, List<List<SubjectData>>>(
  (ref) => OverlappingSubjects(),
);
