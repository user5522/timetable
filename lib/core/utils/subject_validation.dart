import 'package:timetable/core/db/database.dart';
import 'package:timetable/core/utils/time_management.dart';

/// Handles validation logic for subject scheduling conflicts
/// basically manages overlap detection between subjects
class SubjectValidation {
  final List<SubjectData> subjectsInSameDay;
  final List<int> inputHours;
  final SubjectData newSubject;
  final SubjectData? currentSubject;
  final List<List<SubjectData>> overlappingSubjects;

  SubjectValidation({
    required this.subjectsInSameDay,
    required this.inputHours,
    required this.newSubject,
    required this.currentSubject,
    required this.overlappingSubjects,
  });

  bool get isInOverlappingList => overlappingSubjects.any(
        (group) => group.any((subject) => newSubject == subject),
      );

  bool get hasMultipleOccupants =>
      !isInOverlappingList && getConflictingSubjects().length > 1;

  bool get isOccupiedByOverlapping => getOverlappingConflicts().isNotEmpty;

  bool get isOccupiedByRegular => getRegularConflicts().isNotEmpty;

  List<SubjectData> getConflictingSubjects() {
    return subjectsInSameDay
        .where((s) => s != currentSubject)
        .where((s) => s.timetable == newSubject.timetable)
        .where((s) => hasTimeConflict(s))
        .toList();
  }

  List<SubjectData> getOverlappingConflicts() {
    return subjectsInSameDay
        .where((s) => overlappingSubjects.any((group) => group.contains(s)))
        .where((s) => s.timetable == newSubject.timetable)
        .where((s) => hasTimeConflict(s))
        .toList();
  }

  List<SubjectData> getRegularConflicts() {
    return subjectsInSameDay
        .where((s) => s != currentSubject)
        .where((s) => !overlappingSubjects.any((group) => group.contains(s)))
        .where((s) => s.timetable == newSubject.timetable)
        .where((s) => hasTimeConflict(s))
        .toList();
  }

  bool hasTimeConflict(SubjectData subject) {
    final subjectHours = getHoursList(subject.startTime, subject.endTime);
    return hasTimeOverlap(subjectHours, inputHours);
  }

  bool get hasConflicts => isOccupiedByOverlapping && hasMultipleOccupants;
  bool get hasConflictsForExisting =>
      isOccupiedByRegular || hasMultipleOccupants;
}
