import 'package:flutter/material.dart';

// this should be in the helpers folder not the widgets one i think
Future<TimeOfDay?> timePicker(BuildContext context, TimeOfDay time) async {
  return await showTimePicker(
    context: context,
    initialEntryMode: TimePickerEntryMode.input,
    initialTime: time,
  );
}
