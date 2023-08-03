import 'package:flutter/material.dart';

const List<String> times24h = [
  '01',
  '02',
  '03',
  '04',
  '05',
  '06',
  '07',
  '08',
  '09',
  '10',
  '11',
  '12',
  '13',
  '14',
  '15',
  '16',
  '17',
  '18',
  '19',
  '20',
  '21',
  '22',
  '23',
  '00',
];

const List<String> timespmam = [
  '1\nAM',
  '2\nAM',
  '3\nAM',
  '4\nAM',
  '5\nAM',
  '6\nAM',
  '7\nAM',
  '8\nAM',
  '9\nAM',
  '10\nAM',
  '11\nAM',
  '12\nPM',
  '1\nPM',
  '2\nPM',
  '3\nPM',
  '4\nPM',
  '5\nPM',
  '6\nPM',
  '7\nPM',
  '8\nPM',
  '9\nPM',
  '10\nPM',
  '11\nPM',
  '12\nAM',
];

List<String> getTimesList(BuildContext context) {
  bool use24HourFormat = MediaQuery.of(context).alwaysUse24HourFormat;

  return use24HourFormat ? times24h : timespmam;
}

String getFormattedTime(int rowIndex, BuildContext context,
    {int startHour = 0}) {
  List<String> currentTimesList = getTimesList(context);

  int totalHours = currentTimesList.length;
  int hour = (startHour + rowIndex) % totalHours;

  if (hour <= 0) {
    hour += totalHours;
  }

  return currentTimesList[hour - 1];
}
