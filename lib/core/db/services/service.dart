import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart' as drift;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:timetable/core/constants/days.dart';
import 'package:timetable/core/constants/rotation_weeks.dart';
import 'package:timetable/core/db/database.dart';
import 'package:timetable/core/utils/request_permission.dart';

Future<void> shareFile(File file) async {
  Share.shareXFiles([XFile(file.path)]);
}

Future<File> createJSONFile(String fileName, String content) async {
  final directory = await getApplicationDocumentsDirectory();
  final file = File('${directory.path}/$fileName');
  await file.writeAsString(content);
  return file;
}

/// handles data export/backup
Future<void> exportData(AppDatabase db) async {
  final DateTime now = DateTime.now();
  final String date =
      '${now.hour}-${now.minute}_${now.day}-${now.month}-${now.year}';
  final String fileName = 'timetable_backup_$date.json';

  try {
    final isGranted = await requestStoragePermission();
    if (!isGranted) return;

    final Map<String, List<dynamic>> allData = {
      'subject': await db.subject.select().get(),
      'timetable': await db.timetable.select().get(),
    };

    final jsonData = jsonEncode(allData);

    File createdFile = await createJSONFile(fileName, jsonData);

    shareFile(createdFile);
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
