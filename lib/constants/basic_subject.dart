import 'package:flutter/material.dart';
import 'package:timetable/constants/days.dart';
import 'package:timetable/constants/rotation_weeks.dart';
import 'package:timetable/db/database.dart';

/// A basic subject with no additional information.
/// Used for the color autocomplete feature.
final basicSubject = SubjectData(
  id: 0,
  label: " ",
  location: "",
  color: Colors.black.value,
  startTime: const TimeOfDay(hour: 8, minute: 0),
  endTime: const TimeOfDay(hour: 18, minute: 0),
  day: Days.monday,
  rotationWeek: RotationWeeks.all,
  note: "",
);
