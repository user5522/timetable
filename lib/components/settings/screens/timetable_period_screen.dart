import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:timetable/constants/custom_times.dart';
import 'package:timetable/extensions/time_of_day.dart';
import 'package:timetable/helpers/time_management.dart';
import 'package:timetable/provider/settings.dart';

/// Screen to manage the period of the timetable.
///
/// Changes the start time and end time of the timetable.
class TimetablePeriodScreen extends ConsumerWidget {
  const TimetablePeriodScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customTimePeriod = ref.watch(settingsProvider).customTimePeriod;
    final customStartTime = ref.watch(settingsProvider).customStartTime;
    final customEndTime = ref.watch(settingsProvider).customEndTime;
    final twentyFourHours = ref.watch(settingsProvider).twentyFourHours;
    final settings = ref.read(settingsProvider.notifier);

    /// error dialog when the start time and end time have the same value (equal)
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

    /// switches the start and end time of the timetable
    ///
    /// used when the start time is after the end time that
    void switchStartWithEndTime(TimeOfDay newTime) {
      final temp = customEndTime;
      settings.updateCustomEndTime(newTime);
      settings.updateCustomStartTime(temp);
      return;
    }

    /// switches the end and start time of the timetable
    ///
    /// used when the end time is before the start time that
    void switchEndWithStartTime(TimeOfDay newTime) {
      final temp = customStartTime;
      settings.updateCustomStartTime(newTime);
      settings.updateCustomEndTime(temp);
      return;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("period_preferences").tr(),
      ),
      body: ListView(
        children: [
          Column(
            children: [
              SwitchListTile(
                title: const Text("custom_time_period").tr(),
                value: customTimePeriod,
                onChanged: (bool value) {
                  settings.updateCustomTimePeriod(value);
                  if (twentyFourHours) {
                    settings.update24Hours(!value);
                  }
                },
              ),
              SwitchListTile(
                title: const Text("24_hour_period").tr(),
                value: twentyFourHours,
                onChanged: (bool value) {
                  settings.update24Hours(value);
                  if (customTimePeriod) {
                    settings.updateCustomTimePeriod(false);
                  }
                },
              ),
              ListTile(
                dense: true,
                title: const Text("configuration").tr(),
                enabled: customTimePeriod ? true : false,
                textColor: Theme.of(context).colorScheme.primary,
              ),
              ListTile(
                title: const Text("start_time").tr(),
                enabled: customTimePeriod ? true : false,
                subtitle: Text(
                  "${getCustomTimeHour(customStartTime)}:${getCustomTimeMinute(customStartTime)}",
                ),
                onTap: () async {
                  final TimeOfDay? selectedTime = await timePicker(
                    context,
                    customStartTime,
                  );
                  if (selectedTime == null) return;

                  if (selectedTime.hour == customEndTime.hour) {
                    showInvalidEqualTimeDialog();
                    return;
                  }

                  if (selectedTime.isAfter(customEndTime)) {
                    switchStartWithEndTime(selectedTime);
                    return;
                  }

                  settings.updateCustomStartTime(selectedTime);
                },
              ),
              ListTile(
                title: const Text("end_time").tr(),
                enabled: customTimePeriod ? true : false,
                subtitle: Text(
                  "${getCustomTimeHour(customEndTime)}:${getCustomTimeMinute(customEndTime)}",
                ),
                onTap: () async {
                  final TimeOfDay? selectedTime = await timePicker(
                    context,
                    customEndTime,
                  );
                  if (selectedTime == null) return;

                  if (selectedTime.hour == customStartTime.hour) {
                    showInvalidEqualTimeDialog();
                    return;
                  }

                  if (selectedTime.isBefore(customStartTime)) {
                    switchEndWithStartTime(selectedTime);
                    return;
                  }

                  settings.updateCustomEndTime(selectedTime);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
