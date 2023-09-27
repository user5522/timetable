import 'package:flutter/material.dart';
import 'package:timetable/models/subjects.dart';

enum RotationWeeks {
  all,
  none,
  a,
  b,
}

String getRotationWeekLabel(RotationWeeks rotationWeek) {
  switch (rotationWeek) {
    case RotationWeeks.none:
      return "All Weeks";
    case RotationWeeks.a:
      return "Week A";
    case RotationWeeks.b:
      return "Week B";
    default:
      return "All Weeks";
  }
}

String getRotationWeekButtonLabel(RotationWeeks rotationWeek) {
  switch (rotationWeek) {
    case RotationWeeks.none:
      return "All";
    case RotationWeeks.a:
      return "A";
    case RotationWeeks.b:
      return "B";
    default:
      return "All";
  }
}

List<Subject> getFilteredSubject(
    ValueNotifier<RotationWeeks> rotationWeek, List<Subject> allSubjects) {
  switch (rotationWeek.value) {
    case RotationWeeks.all:
      return allSubjects
          .where(
            (s) =>
                s.rotationWeek == RotationWeeks.none ||
                s.rotationWeek == RotationWeeks.a ||
                s.rotationWeek == RotationWeeks.b,
          )
          .toList();
    case RotationWeeks.a:
      return allSubjects
          .where(
            (s) =>
                s.rotationWeek == RotationWeeks.none ||
                s.rotationWeek == RotationWeeks.a,
          )
          .toList();
    case RotationWeeks.b:
      return allSubjects
          .where(
            (s) =>
                s.rotationWeek == RotationWeeks.none ||
                s.rotationWeek == RotationWeeks.b,
          )
          .toList();
    default:
      return allSubjects
          .where(
            (s) =>
                s.rotationWeek == RotationWeeks.none ||
                s.rotationWeek == RotationWeeks.a ||
                s.rotationWeek == RotationWeeks.b,
          )
          .toList();
  }
}

String getSubjectRotationWeekLabel(Subject subject) {
  switch (subject.rotationWeek) {
    case RotationWeeks.a:
      return "A";
    case RotationWeeks.b:
      return "B";
    case RotationWeeks.none:
      return "";
    default:
      return "";
  }
}
