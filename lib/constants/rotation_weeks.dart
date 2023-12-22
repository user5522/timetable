import 'package:flutter/material.dart';
import 'package:timetable/db/database.dart';

/// Basic Rotation Weeks.
enum RotationWeeks {
  all,
  none,
  a,
  b,
}

/// Rotation Weeks button label. (used in the rotation week modal bottom sheet)
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

/// Rotation Weeks action button label. (used in the rotation week selection action button)
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

/// Filters the list of subjects based on the selected rotation week.
List<SubjectData> getFilteredByRotationWeeksSubjects(
  ValueNotifier<RotationWeeks> rotationWeek,
  List<SubjectData> allSubjects,
) {
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

/// Returns rotation week label of a Subject.
String getSubjectRotationWeekLabel(SubjectData subject) {
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
