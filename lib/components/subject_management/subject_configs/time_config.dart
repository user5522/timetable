import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:timetable/components/widgets/act_chip.dart';
import 'package:timetable/components/widgets/time_picker.dart';
import 'package:timetable/helpers/time_management.dart';
import 'package:timetable/constants/custom_times.dart';
import 'package:timetable/provider/settings.dart';

/// Time configuration part of the Subject creation screen.
class TimeConfig extends ConsumerWidget {
  final bool occupied;
  final ValueNotifier<TimeOfDay> startTime;
  final ValueNotifier<TimeOfDay> endTime;

  const TimeConfig({
    super.key,
    required this.occupied,
    required this.startTime,
    required this.endTime,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customStartTime = ref.watch(settingsProvider).customStartTime;
    final customEndTime = ref.watch(settingsProvider).customEndTime;
    final customTimePeriod = ref.watch(settingsProvider).customTimePeriod;

    void showInvalidTimePeriodDialog() {
      final String customStartTimeHour =
          customTimePeriod ? getCustomTimeHour(customStartTime) : "08";
      final String customStartTimeMinute =
          customTimePeriod ? getCustomTimeMinute(customStartTime) : "00";
      final String customEndTimeHour =
          customTimePeriod ? getCustomTimeHour(customEndTime) : "18";
      final String customEndTimeMinute =
          customTimePeriod ? getCustomTimeMinute(customEndTime) : "00";

      final String startTime = "$customStartTimeHour:$customStartTimeMinute";
      final String endTime = "$customEndTimeHour:$customEndTimeMinute";

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Invalid Time'),
          content: Text(
            'Time period must be between $startTime and $endTime.',
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

    return Row(
      children: [
        const Text("Time"),
        const Spacer(),
        ActChip(
          onPressed: () async {
            final TimeOfDay? selectedTime = await timePicker(
              context,
              TimeOfDay(
                hour: startTime.value.hour,
                minute: 0,
              ),
            );

            if (selectedTime != null &&
                (selectedTime.hour <
                    getCustomStartTime(customStartTime, ref).hour)) {
              showInvalidTimePeriodDialog();
            } else if (selectedTime != null) {
              if (isBefore(selectedTime, endTime.value)) {
                startTime.value = selectedTime;
              } else {
                showInvalidTimeDialog(true);
              }
            }
          },
          label: Text("${startTime.value.hour}:00"),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 10,
          ),
          child: Icon(Icons.arrow_forward),
        ),
        ActChip(
          onPressed: () async {
            final TimeOfDay? selectedTime = await timePicker(
              context,
              TimeOfDay(
                hour: endTime.value.hour,
                minute: 0,
              ),
            );

            if (selectedTime != null &&
                (selectedTime.hour >
                    getCustomEndTime(customEndTime, ref).hour)) {
              showInvalidTimePeriodDialog();
            } else if (selectedTime != null) {
              if (isAfter(selectedTime, startTime.value)) {
                endTime.value = selectedTime;
              } else {
                showInvalidTimeDialog(false);
              }
            }
          },
          label: Text("${endTime.value.hour}:00"),
        ),
        if (occupied)
          const Padding(
            padding: EdgeInsets.only(left: 10),
            child: Icon(
              Icons.cancel,
              color: Colors.redAccent,
            ),
          ),
      ],
    );
  }
}
