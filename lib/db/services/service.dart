import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart' as drift;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:timetable/constants/days.dart';
import 'package:timetable/constants/rotation_weeks.dart';
import 'package:timetable/db/database.dart';

final DateTime now = DateTime.now();
final String date =
    '${now.hour}:${now.minute}_${now.day}-${now.month}-${now.year}';
final String fileName = 'timetable_backup $date.json';

/// handles data export/backup
Future<void> exportData(
  AppDatabase db,
) async {
  try {
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
    if (selectedDirectory == null) return;

    final Map<String, List<dynamic>> allData = {
      'subject': await db.subject.select().get(),
      'timetable': await db.timetable.select().get(),
    };

    final jsonData = jsonEncode(allData);

    await File('$selectedDirectory/$fileName').writeAsString(jsonData);
  } catch (_) {}
}

/// handles data import/restore
Future<void> restoreData(
  AppDatabase db,
) async {
  try {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    File file;

    if (result == null) return;
    file = File(result.files.single.path!);

    final jsonData = await file.readAsString();
    final decodedData = jsonDecode(jsonData) as Map<String, dynamic>;

    for (final table in decodedData.keys) {
      final subjectsTable = db.subject;
      final timetablesTable = db.timetable;

      if (table == 'subject') {
        subjectsTable.deleteAll();

        for (final element in decodedData[table]!) {
          subjectsTable.insertOne(
            SubjectCompanion.insert(
              label: element["label"],
              location: drift.Value(element["location"]),
              note: drift.Value(element["note"]),
              color: Color(element["color"]),
              rotationWeek: RotationWeeks.values[element["rotationWeek"]],
              day: Days.values[element["day"]],
              startTime: TimeOfDay(
                  hour: element["startTimeHour"],
                  minute: element["startTimeMinute"]),
              endTime: TimeOfDay(
                hour: element["endTimeHour"],
                minute: element["endTimeMinute"],
              ),
              timetable: element["timetable"],
            ),
          );
        }
      }

      if (table == 'timetable') {
        timetablesTable.deleteAll();

        for (final element in decodedData[table]!) {
          timetablesTable.insertOne(
            TimetableCompanion.insert(
              name: element["name"],
            ),
          );
        }
      }
    }
  } catch (_) {}
}
