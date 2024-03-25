import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:timetable/db/database.dart';

/// A [StateNotifier] that holds the list of overlapping subjects.
// idea: maybe i should save the list of overlapping subjects
// instead of trying to find them everytime the app is opened
// should help with performance, probably
class OverlappingSubjects extends StateNotifier<List<List<SubjectData>>> {
  OverlappingSubjects() : super([]);

  /// adds a whole list of subjects to the state
  void addInBulk(List<List<SubjectData>> value) {
    state = value;
  }

  /// deletes all current data, usually to fetch new data and avoid errors
  void reset() {
    state = [];
  }
}

final overlappingSubjectsProvider =
    StateNotifierProvider<OverlappingSubjects, List<List<SubjectData>>>(
  (ref) => OverlappingSubjects(),
);
