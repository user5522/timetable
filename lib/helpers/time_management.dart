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

/// generate hours list between start and end time
List<int> getHoursList(TimeOfDay start, TimeOfDay end) {
  return List.generate(
    end.hour - start.hour,
    (index) => index + start.hour,
  );
}

// check if two time slots overlap
bool hasTimeOverlap(List<int> hours1, List<int> hours2) {
  return hours1.any((hour) => hours2.contains(hour));
}
