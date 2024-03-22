import 'package:easy_localization/easy_localization.dart';
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
    final chosenCustomStartTime = ref.watch(settingsProvider).customStartTime;
    final chosenCustomEndTime = ref.watch(settingsProvider).customEndTime;
    // final customTimePeriod = ref.watch(settingsProvider).customTimePeriod;

    final customStartTime = getCustomStartTime(chosenCustomStartTime, ref);
    final customEndTime = getCustomEndTime(chosenCustomEndTime, ref);

    void showInvalidTimePeriodDialog() {
      final String customStartTimeHour = getCustomTimeHour(customStartTime);
      final String customStartTimeMinute = getCustomTimeMinute(customStartTime);
      final String customEndTimeHour = getCustomTimeHour(customEndTime);
      final String customEndTimeMinute = getCustomTimeMinute(customEndTime);

      final String startTime = "$customStartTimeHour:$customStartTimeMinute";
      final String endTime = "$customEndTimeHour:$customEndTimeMinute";

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('invalid_time').tr(),
          content:
              const Text('invalid_time_config').tr(args: [startTime, endTime]),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('ok').tr(),
            ),
          ],
        ),
      );
    }

    void showInvalidEqualTimeDialog() {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('invalid_time').tr(),
          content: const Text('invalid_equal_time_error').tr(),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('ok').tr(),
            ),
          ],
        ),
      );
    }

    void switchStartWithEndTime(TimeOfDay newTime) {
      if (!isAfter(newTime, customEndTime)) {
        final temp = endTime.value;
        endTime.value = newTime;
        startTime.value = temp;
        return;
      }
      showInvalidTimePeriodDialog();
    }

    void switchEndWithStartTime(TimeOfDay newTime) {
      if (!isBefore(newTime, customStartTime)) {
        final temp = startTime.value;
        startTime.value = newTime;
        endTime.value = temp;
        return;
      }
      showInvalidTimePeriodDialog();
    }

    return Row(
      children: [
        const Text("time").tr(),
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

            if (selectedTime == null) return;

            if (isBefore(selectedTime, customStartTime)) {
              showInvalidTimePeriodDialog();
              return;
            }

            if (selectedTime == endTime.value) {
              showInvalidEqualTimeDialog();
              return;
            }

            if (isAfter(selectedTime, endTime.value)) {
              switchStartWithEndTime(selectedTime);
              return;
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

            if (selectedTime == null) return;

            if (isAfter(selectedTime, customEndTime)) {
              showInvalidTimePeriodDialog();
              return;
            }

            if (selectedTime == startTime.value) {
              showInvalidEqualTimeDialog();
              return;
            }
            if (isBefore(selectedTime, startTime.value)) {
              switchEndWithStartTime(selectedTime);
              return;
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
