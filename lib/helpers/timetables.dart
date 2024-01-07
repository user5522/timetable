import 'package:flutter/material.dart';
import 'package:timetable/db/database.dart';

List<SubjectData> getFilteredByTimetablesSubjects(
  ValueNotifier<TimetableData> currentTimetable,
  List<TimetableData> timetables,
  bool multipleTimetables,
  List<SubjectData> allSubjects,
) {
  if (multipleTimetables && timetables.length != 1) {
    return allSubjects
        .where((s) => s.timetable == currentTimetable.value.name)
        .toList();
  }
  return allSubjects.where((e) => e.timetable == "1").toList();
}