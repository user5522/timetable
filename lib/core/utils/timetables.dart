import 'package:flutter/material.dart';
import 'package:timetable/core/db/database.dart';

/// filters subjects based on the current selected timetable
// this should probably be in the subjects helper since it handles subjects
List<SubjectData> getFilteredByTimetablesSubjects(
  ValueNotifier<TimetableData> currentTimetable,
  List<TimetableData> timetables,
  bool multipleTimetables,
  List<SubjectData> allSubjects,
) {
  return allSubjects
      .where((s) => s.timetable == currentTimetable.value.name)
      .toList();
}
