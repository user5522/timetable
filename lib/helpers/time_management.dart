import 'package:flutter/material.dart';

/// returns a time picker
///
/// initialEntryMode is set by default to [TimePickerEntryMode.input]
Future<TimeOfDay?> timePicker(BuildContext context, TimeOfDay time) async {
  return await showTimePicker(
    context: context,
    initialEntryMode: TimePickerEntryMode.input,
    initialTime: time,
  );
}
