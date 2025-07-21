import 'package:flutter/material.dart';
import 'package:timetable/core/constants/days.dart';
import 'package:timetable/core/constants/rotation_weeks.dart';
import 'package:timetable/core/db/database.dart';
import 'package:timetable/core/utils/time_management.dart';

/// Handles validation logic for subject scheduling conflicts
/// basically manages overlap detection between subjects
class SubjectValidation {
  final List<Subject> subjectsInSameDay;
  final List<int> inputHours;
  final int subjectId;
  final String label;
  final String? location;
  final Color color;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final Day day;
  final RotationWeeks rotationWeek;
  final String? note;
  final String timetable;
  final Subject? currentSubject;
  final List<List<Subject>> overlappingSubjects;

  SubjectValidation({
    required this.subjectsInSameDay,
    required this.inputHours,
    required this.subjectId,
    required this.label,
    required this.location,
    required this.color,
    required this.startTime,
    required this.endTime,
    required this.day,
    required this.rotationWeek,
    required this.note,
    required this.timetable,
    required this.currentSubject,
    required this.overlappingSubjects,
  });

  Subject get _tempSubject => Subject(
        id: subjectId,
        label: label,
        location: location,
        color: color,
        startTime: startTime,
        endTime: endTime,
        day: day,
        rotationWeek: rotationWeek,
        note: note,
        timetable: timetable,
      );

  List<Subject> getConflictingSubjects() {
    return subjectsInSameDay
        .where((s) => s != currentSubject)
        .where((s) => s.timetable == _tempSubject.timetable)
        .where((s) => hasTimeConflict(s))
        .toList();
  }

  bool hasTimeConflict(Subject subject) {
    final subjectHours = getHoursList(subject.startTime, subject.endTime);
    return hasTimeOverlap(subjectHours, inputHours);
  }

  bool get wouldExceedMaxOverlap {
    if (currentSubject != null) return false;

    final allSubjectsInDay = subjectsInSameDay
        .where((s) => s != currentSubject)
        .where((s) => s.timetable == _tempSubject.timetable)
        .toList();

    if (allSubjectsInDay.isEmpty) return false;

    for (final hour in inputHours) {
      int overlapCount = 1;

      for (final subject in allSubjectsInDay) {
        final subjectHours = getHoursList(subject.startTime, subject.endTime);
        if (subjectHours.contains(hour)) {
          overlapCount++;
        }
      }

      if (overlapCount > 3) return true;
    }

    return false;
  }

  bool get hasConflicts => wouldExceedMaxOverlap;
  bool get hasConflictsForExisting => false;
}
