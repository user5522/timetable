import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:timetable/constants/days.dart';
import 'package:timetable/constants/rotation_weeks.dart';
import 'package:timetable/db/database.dart';

const String fileName = 'timetable_backup.json';

void exportData(
  AppDatabase db,
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> snackBar,
) async {
  try {
    final documentsDirectory = await getApplicationDocumentsDirectory();

    final allData = {
      'subject': await $SubjectTable(db).select().get(),
      'timetable': await $TimetableTable(db).select().get(),
    };

    final jsonData = jsonEncode(allData);

    await File('$documentsDirectory/$fileName').writeAsString(jsonData);

    snackBar;
  } catch (_) {
    // print('Error exporting data: $error');
  }
}

Future<void> restoreData(
  AppDatabase db,
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> snackBar,
) async {
  try {
    final documentsDirectory = await getApplicationDocumentsDirectory();

    final jsonData = await File('$documentsDirectory/$fileName').readAsString();
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

    snackBar;
  } catch (_) {
    // print('Error restoring data: $error');
  }
}
