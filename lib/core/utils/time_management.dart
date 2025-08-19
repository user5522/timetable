import 'package:flutter/material.dart';

/// returns a time picker
///
/// initialEntryMode is set by default to [TimePickerEntryMode.input]
Future<TimeOfDay?> timePicker({
  required TimeOfDay time,
  required BuildContext context,
}) async {
  return await showTimePicker(
    context: context,
    initialEntryMode: TimePickerEntryMode.input,
    initialTime: time,
  );
}

/// generate hours list between start and end time
List<int> getHoursList(TimeOfDay start, TimeOfDay end) {
  return List.generate(
    end.hour - start.hour,
    (index) => index + start.hour,
  );
}
