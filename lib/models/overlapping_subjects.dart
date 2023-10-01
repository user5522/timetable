import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:timetable/models/subjects.dart';

class OverlappingSubjects extends StateNotifier<List<List<Subject>>> {
  OverlappingSubjects() : super([]);
}

final overlappingSubjectsProvider =
    StateNotifierProvider<OverlappingSubjects, List<List<Subject>>>(
  (ref) => OverlappingSubjects(),
);
