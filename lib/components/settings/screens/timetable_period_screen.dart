import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:timetable/constants/custom_times.dart';
import 'package:timetable/provider/settings.dart';

/// Screen to manage the period of the timetable.
/// Changes the start time and end time of the timetable.
class TimetablePeriodScreen extends ConsumerWidget {
  const TimetablePeriodScreen({super.key});

  bool _isBefore(TimeOfDay time1, TimeOfDay time2) {
    return (time1.hour < time2.hour) ||
        (time1.hour == time2.hour && time1.minute < time2.minute);
  }

  bool _isAfter(TimeOfDay time1, TimeOfDay time2) {
    return (time1.hour > time2.hour) ||
        (time1.hour == time2.hour && time1.minute > time2.minute);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customTimePeriod = ref.watch(settingsProvider).customTimePeriod;
    final customStartTime = ref.watch(settingsProvider).customStartTime;
    final customEndTime = ref.watch(settingsProvider).customEndTime;
    final settings = ref.read(settingsProvider.notifier);

    void showInvalidTimeDialog(bool isStartTime) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Invalid Time'),
          content: Text(
            'The ${isStartTime ? "start" : "end"} time must be ${isStartTime ? "before" : "after"} the ${isStartTime ? "end" : "start"} time.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Period Preferences"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SwitchListTile(
              title: const Text("Custom Time Period"),
              value: customTimePeriod,
              onChanged: (bool value) {
                settings.updateCustomTimePeriod(value);
              },
            ),
            ListTile(
              dense: true,
              title: const Text("Configuration"),
              enabled: customTimePeriod ? true : false,
              textColor: Theme.of(context).colorScheme.primary,
            ),
            ListTile(
              title: const Text("Timetable Start Time"),
              enabled: customTimePeriod ? true : false,
              subtitle: Text(
                "${getCustomTimeHour(customStartTime)}:${getCustomTimeMinute(customStartTime)}",
              ),
              onTap: () async {
                final TimeOfDay? selectedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay(
                    hour: customStartTime.hour,
                    minute: customStartTime.minute,
                  ),
                );
                if (selectedTime != null) {
                  if (_isBefore(selectedTime, customEndTime)) {
                    return settings.updateCustomStartTime(selectedTime);
                  } else {
                    showInvalidTimeDialog(true);
                  }
                }
              },
            ),
            ListTile(
              title: const Text("Timetable End Time"),
              enabled: customTimePeriod ? true : false,
              subtitle: Text(
                "${getCustomTimeHour(customEndTime)}:${getCustomTimeMinute(customEndTime)}",
              ),
              onTap: () async {
                final TimeOfDay? selectedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay(
                    hour: customEndTime.hour,
                    minute: customEndTime.minute,
                  ),
                );
                if (selectedTime != null) {
                  if (_isAfter(selectedTime, customStartTime)) {
                    return settings.updateCustomEndTime(selectedTime);
                  } else {
                    showInvalidTimeDialog(false);
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
