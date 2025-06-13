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
  final Days day;
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

  bool get isInOverlappingList => overlappingSubjects.any(
        (group) => group.any((subject) => _tempSubject == subject),
      );

  bool get hasMultipleOccupants =>
      !isInOverlappingList && getConflictingSubjects().length > 1;

  bool get isOccupiedByOverlapping => getOverlappingConflicts().isNotEmpty;

  bool get isOccupiedByRegular => getRegularConflicts().isNotEmpty;

  List<Subject> getConflictingSubjects() {
    return subjectsInSameDay
        .where((s) => s != currentSubject)
        .where((s) => s.timetable == _tempSubject.timetable)
        .where((s) => hasTimeConflict(s))
        .toList();
  }

  List<Subject> getOverlappingConflicts() {
    return subjectsInSameDay
        .where((s) => overlappingSubjects.any((group) => group.contains(s)))
        .where((s) => s.timetable == _tempSubject.timetable)
        .where((s) => hasTimeConflict(s))
        .toList();
  }

  List<Subject> getRegularConflicts() {
    return subjectsInSameDay
        .where((s) => s != currentSubject)
        .where((s) => !overlappingSubjects.any((group) => group.contains(s)))
        .where((s) => s.timetable == _tempSubject.timetable)
        .where((s) => hasTimeConflict(s))
        .toList();
  }

  bool hasTimeConflict(Subject subject) {
    final subjectHours = getHoursList(subject.startTime, subject.endTime);
    return hasTimeOverlap(subjectHours, inputHours);
  }

  bool get hasConflicts => isOccupiedByOverlapping && hasMultipleOccupants;
  bool get hasConflictsForExisting =>
      isOccupiedByRegular || hasMultipleOccupants;
}
