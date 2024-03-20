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
    '${now.year}-${now.month}-${now.day}_${now.hour}-${now.minute}';
final String fileName = 'timetable_backup $date.json';

void exportData(
  AppDatabase db,
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> snackBar,
) async {
  try {
    final allData = {
      'subject': await $SubjectTable(db).select().get(),
      'timetable': await $TimetableTable(db).select().get(),
    };

    final jsonData = jsonEncode(allData);

    final a = await File('storage/emulated/0/Documents/$fileName')
        .writeAsString(jsonData);

    a;
    snackBar;
  } catch (error) {
    // print('Error exporting data: $error');
  }
}

Future<void> restoreData(
  AppDatabase db,
) async {
  try {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    File file;

    if (result != null) {
      file = File(result.files.single.path!);
    } else {
      return;
    }

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
  } catch (_) {
    // print('Error restoring data: $error');
  }
}
