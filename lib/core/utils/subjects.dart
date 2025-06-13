import 'package:flutter/material.dart';
import 'package:timetable/core/db/database.dart';

/// sorts subjects by time
List<SubjectData> sortSubjects(List<SubjectData> subjects) {
  subjects.sort((a, b) => a.startTime.hour.compareTo(b.startTime.hour));

  return subjects;
}

/// increments a value by 1 and resets when it reaches a specified length
///
/// used in the filter toggles
void increment(ValueNotifier<int> value, int length) {
  value.value++;
  if (value.value >= length) {
    value.value = 0;
  }
}
