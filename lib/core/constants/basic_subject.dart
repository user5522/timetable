import 'package:flutter/material.dart';
import 'package:timetable/core/constants/days.dart';
import 'package:timetable/core/constants/rotation_weeks.dart';
import 'package:timetable/core/db/database.dart';

/// A basic subject with no extra information.
/// Used for the color autocomplete feature.
const basicSubject = Subject(
  id: 0,
  label: " ",
  location: "",
  color: Colors.black,
  startTime: TimeOfDay(hour: 8, minute: 0),
  endTime: TimeOfDay(hour: 18, minute: 0),
  day: Days.monday,
  rotationWeek: RotationWeeks.all,
  note: "",
  timetable: "1",
);
