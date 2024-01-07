import 'package:flutter/material.dart';
import 'package:timetable/constants/rotation_weeks.dart';
import 'package:timetable/db/database.dart';

/// filters overlapping subjects from the list of all subjects.
List<SubjectData> filterOverlappingSubjects(
  List<SubjectData> subjects,
  List<List<SubjectData>> overlappingSubjects,
) {
  return subjects
      .where(
        (e) => !overlappingSubjects.any((elem) => elem.contains(e)),
      )
      .toList();
}

/// Returns the subject with the earlier starting time.
SubjectData getEarliestSubject(List<SubjectData> subjects) {
  SubjectData earliestSubject = subjects[0];
  for (final subject in subjects) {
    if (subject.startTime.hour < earliestSubject.startTime.hour) {
      earliestSubject = subject;
    }
  }
  return earliestSubject;
}

/// Returns the subject with the later ending time.
SubjectData getLatestSubject(List<SubjectData> subjects) {
  SubjectData latestSubject = subjects.first;
  for (final subject in subjects) {
    if (subject.endTime.hour > latestSubject.endTime.hour) {
      latestSubject = subject;
    }
  }
  return latestSubject;
}

/// filters overlapping subjects by the current rotation week.
void filterOverlappingSubjectsByRotationWeeks(
  List<List<SubjectData>> overlappingSubjects,
  ValueNotifier<RotationWeeks> rotationWeek,
) {
  return overlappingSubjects.removeWhere(
    (elem) => elem.any(
      (e) {
        if (rotationWeek.value == RotationWeeks.a) {
          return e.rotationWeek == RotationWeeks.b;
        } else if (rotationWeek.value == RotationWeeks.b) {
          return e.rotationWeek == RotationWeeks.a;
        } else {
          return false;
        }
      },
    ),
  );
}

/// filters overlapping subjects by the current timetable.
void filterOverlappingSubjectsByTimetable(
  List<List<SubjectData>> overlappingSubjects,
  ValueNotifier<TimetableData> currentTimetable,
  List<TimetableData> timetables,
) {
  return overlappingSubjects.removeWhere(
    (elem) => elem.any(
      (e) => e.timetable != currentTimetable.value.name,
    ),
  );
}
