import 'package:flutter/material.dart';
import 'package:timetable/core/constants/rotation_weeks.dart';
import 'package:timetable/core/db/database.dart';

/// filters overlapping subjects from the list of all subjects.
List<Subject> filterOverlappingSubjects(
  List<Subject> subjects,
  List<List<Subject>> overlappingSubjects,
) {
  return subjects
      .where(
        (e) => !overlappingSubjects.any((elem) => elem.contains(e)),
      )
      .toList();
}

/// Returns the subject with the earlier starting time.
Subject getEarliestSubject(List<Subject> subjects) {
  Subject earliestSubject = subjects[0];
  for (final subject in subjects) {
    if (subject.startTime.hour < earliestSubject.startTime.hour) {
      earliestSubject = subject;
    }
  }
  return earliestSubject;
}

/// Returns the subject with the later ending time.
Subject getLatestSubject(List<Subject> subjects) {
  Subject latestSubject = subjects.first;
  for (final subject in subjects) {
    if (subject.endTime.hour > latestSubject.endTime.hour) {
      latestSubject = subject;
    }
  }
  return latestSubject;
}

/// filters overlapping subjects by the current rotation week.
void filterOverlappingSubjectsByRotationWeeks(
  List<List<Subject>> overlappingSubjects,
  ValueNotifier<RotationWeeks> rotationWeek,
) {
  return overlappingSubjects.removeWhere(
    (elem) => elem.any(
      (e) {
        switch (rotationWeek.value) {
          case RotationWeeks.a:
            return e.rotationWeek == RotationWeeks.b;
          case RotationWeeks.b:
            return e.rotationWeek == RotationWeeks.a;
          case RotationWeeks.none:
            return false;
        }
      },
    ),
  );
}

/// filters overlapping subjects by the current timetable.
void filterOverlappingSubjectsByTimetable(
  List<List<Subject>> overlappingSubjects,
  ValueNotifier<Timetable> currentTimetable,
  List<Timetable> timetables,
) {
  return overlappingSubjects.removeWhere(
    (elem) => elem.any(
      (e) => e.timetable != currentTimetable.value.name,
    ),
  );
}

/// checks if 2 subjects overlap in time
bool doSubjectsOverlap(Subject a, Subject b, List<Subject> group) {
  return a.day == b.day &&
      (a.startTime.hour < b.endTime.hour ||
          (a.startTime.hour == b.endTime.hour &&
              a.startTime.minute < b.endTime.minute)) &&
      (a.endTime.hour > b.startTime.hour ||
          (a.endTime.hour == b.startTime.hour &&
              a.endTime.minute > b.startTime.minute)) &&
      (!group.contains(a) || !group.contains(b));
}

void findOverlappingSubjectsWithinGroup(
  List<Subject> subjects,
  List<Subject> group,
  int startIndex,
) {
  for (int i = startIndex; i < subjects.length; i++) {
    if (!group.contains(subjects[i]) &&
        group.any(
          (subject) => doSubjectsOverlap(
            subject,
            subjects[i],
            group,
          ),
        )) {
      group.add(subjects[i]);
      findOverlappingSubjectsWithinGroup(
        subjects,
        group,
        i + 1,
      );
    }
  }
}

List<List<Subject>> findOverlappingSubjects(List<Subject> subjects) {
  final overlappingSubjects = <List<Subject>>[];

  for (int i = 0; i < subjects.length; i++) {
    if (overlappingSubjects.any(
      (group) => group.contains(subjects[i]),
    )) {
      continue;
    }

    final overlappingGroup = <Subject>[subjects[i]];

    for (int j = i + 1; j < subjects.length; j++) {
      if (doSubjectsOverlap(
        subjects[i],
        subjects[j],
        overlappingGroup,
      )) {
        overlappingGroup.add(subjects[j]);

        findOverlappingSubjectsWithinGroup(
          subjects,
          overlappingGroup,
          j + 1,
        );
      }
    }

    overlappingSubjects.add(overlappingGroup);
  }

  return overlappingSubjects.where((e) => e.length > 1).toList();
}

/// checks if 2 subjects overlap in hours
bool overlaps(Subject a, Subject b) {
  return a.startTime.hour < b.endTime.hour && b.startTime.hour < a.endTime.hour;
}
