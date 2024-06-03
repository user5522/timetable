import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:timetable/components/widgets/act_chip.dart';
import 'package:timetable/extensions/time_of_day.dart';
import 'package:timetable/helpers/time_management.dart';
import 'package:timetable/constants/custom_times.dart';
import 'package:timetable/provider/settings.dart';

/// Time configuration part of the Subject creation screen.
class TimeConfig extends ConsumerWidget {
  /// whether or not the current time slot ((endTime - startTime) - tbCustomStartTime) is occupied
  /// used to show the error icon when the time is not valid/unavailable
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

    final customStartTime = getCustomStartTime(chosenCustomStartTime, ref);
    final customEndTime = getCustomEndTime(chosenCustomEndTime, ref);

    final uses24HoursFormat = MediaQuery.of(context).alwaysUse24HourFormat;

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
      if (!newTime.isAfter(customEndTime)) {
        final temp = endTime.value;
        endTime.value = newTime;
        startTime.value = temp;
        return;
      }
      showInvalidTimePeriodDialog();
    }

    void switchEndWithStartTime(TimeOfDay newTime) {
      if (!newTime.isBefore(customStartTime)) {
        final temp = startTime.value;
        startTime.value = newTime;
        endTime.value = temp;
        return;
      }
      showInvalidTimePeriodDialog();
    }

    String getTime(TimeOfDay time) {
      final formattedTimeHour = uses24HoursFormat
          ? time.hour
          : time.hour > 12
              ? time.hour - 12
              : time.hour;
      final amORpm = uses24HoursFormat
          ? null
          : time.hour > 12
              ? "PM"
              : "AM";
      final formattedTimeMinute = time.minute == 0
          ? "00"
          : time.minute < 10
              ? "0${time.minute}"
              : "${time.minute}";

      return "$formattedTimeHour:$formattedTimeMinute $amORpm";
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

            if (selectedTime.isBefore(customStartTime)) {
              showInvalidTimePeriodDialog();
              return;
            }

            if (selectedTime.hour == endTime.value.hour) {
              showInvalidEqualTimeDialog();
              return;
            }

            if (selectedTime.isAfter(endTime.value)) {
              switchStartWithEndTime(selectedTime);
              return;
            }

            startTime.value = selectedTime;
          },
          label: Text(getTime(startTime.value)),
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

            if (selectedTime.isAfter(customEndTime)) {
              showInvalidTimePeriodDialog();
              return;
            }

            if (selectedTime.hour == startTime.value.hour) {
              showInvalidEqualTimeDialog();
              return;
            }
            if (selectedTime.isBefore(startTime.value)) {
              switchEndWithStartTime(selectedTime);
              return;
            }

            endTime.value = selectedTime;
          },
          label: Text(getTime(endTime.value)),
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
