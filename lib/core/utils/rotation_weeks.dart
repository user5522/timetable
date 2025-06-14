import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:timetable/core/constants/rotation_weeks.dart';
import 'package:timetable/core/db/database.dart';

/// Rotation Weeks button label. (used in the rotation week modal bottom sheet)
String getRotationWeekLabel(RotationWeeks rotationWeek) {
  switch (rotationWeek) {
    case RotationWeeks.none:
      return "all_weeks".tr();
    case RotationWeeks.a:
      return "${"week".tr()} A";
    case RotationWeeks.b:
      return "${"week".tr()} B";
    default:
      return "all_weeks".tr();
  }
}

/// Rotation Weeks action button label. (used in the rotation week selection action button)
String getRotationWeekButtonLabel(RotationWeeks rotationWeek) {
  switch (rotationWeek) {
    case RotationWeeks.none:
      return "all".tr();
    case RotationWeeks.a:
      return "A";
    case RotationWeeks.b:
      return "B";
    default:
      return "all".tr();
  }
}

/// Filters the list of subjects based on the selected rotation week.
List<Subject> getFilteredByRotationWeeksSubjects(
  ValueNotifier<RotationWeeks> rotationWeek,
  List<Subject> allSubjects,
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
