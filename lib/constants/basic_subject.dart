import 'package:flutter/material.dart';
import 'package:timetable/constants/days.dart';
import 'package:timetable/constants/rotation_weeks.dart';
import 'package:timetable/models/subjects.dart';

/// A basic subject with no additional information.
/// Used for the color autocomplete feature.
const basicSubject = Subject(
  label: " ",
  location: "",
  color: Colors.black,
  startTime: TimeOfDay(hour: 8, minute: 0),
  endTime: TimeOfDay(hour: 18, minute: 0),
  day: Days.monday,
  rotationWeek: RotationWeeks.all,
  note: "",
);
