import 'package:flutter/material.dart';

Future<TimeOfDay?> timePicker(BuildContext context, TimeOfDay time) async {
  return await showTimePicker(
    context: context,
    initialEntryMode: TimePickerEntryMode.input,
    initialTime: time,
  );
}
