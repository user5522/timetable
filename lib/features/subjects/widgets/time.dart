import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:timetable/core/utils/time_formatter.dart';
import 'package:timetable/shared/widgets/act_chip.dart';
import 'package:timetable/core/utils/time_management.dart';
import 'package:timetable/core/utils/custom_times.dart';
import 'package:timetable/features/settings/providers/settings.dart';

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
    final settings = ref.watch(settingsProvider);
    final chosenCustomStartTime = settings.customStartTime;
    final chosenCustomEndTime = settings.customEndTime;

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

    return Row(
      children: [
        const Text("time").tr(),
        const Spacer(),
        buildTimeChip(
          time: startTime,
          inverseTime: endTime,
          isBoundaryInvalid: (selectedTime) =>
              selectedTime.isBefore(customStartTime),
          showInvalidTimePeriodDialog: showInvalidTimePeriodDialog,
          showInvalidEqualTimeDialog: showInvalidEqualTimeDialog,
          isSwapNeeded: (selectedTime) => selectedTime.isAfter(endTime.value),
          performSwap: (selectedTime) {
            if (!selectedTime.isAfter(customEndTime)) {
              final temp = endTime.value;
              endTime.value = selectedTime;
              startTime.value = temp;
            } else {
              showInvalidTimePeriodDialog();
            }
          },
          uses24HoursFormat: uses24HoursFormat,
          context: context,
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Icon(Icons.arrow_forward),
        ),
        buildTimeChip(
          time: endTime,
          inverseTime: startTime,
          isBoundaryInvalid: (selectedTime) =>
              selectedTime.isAfter(customEndTime),
          showInvalidTimePeriodDialog: showInvalidTimePeriodDialog,
          showInvalidEqualTimeDialog: showInvalidEqualTimeDialog,
          isSwapNeeded: (selectedTime) =>
              selectedTime.isBefore(startTime.value),
          performSwap: (selectedTime) {
            if (!selectedTime.isBefore(customStartTime)) {
              final temp = startTime.value;
              startTime.value = selectedTime;
              endTime.value = temp;
            } else {
              showInvalidTimePeriodDialog();
            }
          },
          uses24HoursFormat: uses24HoursFormat,
          context: context,
        ),
        if (occupied)
          const Padding(
            padding: EdgeInsets.only(left: 10),
            child: Icon(Icons.cancel, color: Colors.redAccent),
          ),
      ],
    );
  }

  Widget buildTimeChip({
    required ValueNotifier<TimeOfDay> time,
    required ValueNotifier<TimeOfDay> inverseTime,
    required bool Function(TimeOfDay selectedTime) isBoundaryInvalid,
    required void Function() showInvalidTimePeriodDialog,
    required void Function() showInvalidEqualTimeDialog,
    required bool Function(TimeOfDay selectedTime) isSwapNeeded,
    required void Function(TimeOfDay selectedTime) performSwap,
    required bool uses24HoursFormat,
    required BuildContext context,
  }) {
    return ActChip(
      onPressed: () async {
        final TimeOfDay? selectedTime = await timePicker(
          time: TimeOfDay(hour: time.value.hour, minute: 0),
          context: context,
        );

        if (selectedTime == null) return;

        if (isBoundaryInvalid(selectedTime)) {
          showInvalidTimePeriodDialog();
          return;
        }

        if (selectedTime.hour == inverseTime.value.hour) {
          showInvalidEqualTimeDialog();
          return;
        }

        if (isSwapNeeded(selectedTime)) {
          performSwap(selectedTime);
          return;
        }

        time.value = selectedTime;
      },
      label:
          Text(TimeFormatter.getTimeNoPadding(time.value, uses24HoursFormat)),
    );
  }
}
