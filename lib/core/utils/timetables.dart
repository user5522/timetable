import 'package:flutter/material.dart';
import 'package:timetable/core/db/database.dart';

/// filters subjects based on the current selected timetable
// this should probably be in the subjects helper since it handles subjects
List<Subject> getFilteredByTimetablesSubjects(
  ValueNotifier<Timetable> currentTimetable,
  List<Timetable> timetables,
  bool multipleTimetables,
  List<Subject> allSubjects,
) {
  return allSubjects
      .where((s) => s.timetable == currentTimetable.value.name)
      .toList();
}
