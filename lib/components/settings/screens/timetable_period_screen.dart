import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:timetable/components/widgets/time_picker.dart';
import 'package:timetable/constants/custom_times.dart';
import 'package:timetable/provider/settings.dart';

/// Screen to manage the period of the timetable.
///
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
    final twentyFourHours = ref.watch(settingsProvider).twentyFourHours;
    final settings = ref.read(settingsProvider.notifier);

    void showInvalidTimeDialog(bool isStartTime) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('invalid_time').tr(),
          content: Text(
            // I know using the gender feature to group dialogs together is stupid but whatever
            isStartTime
                ? "invalid_time_error".tr(gender: "start_time")
                : "invalid_time_error".tr(gender: "end_time"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('ok').tr(),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("period_preferences").tr(),
      ),
      body: SingleChildScrollView(
        child: Column(
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
                if (selectedTime == null) {
                  return;
                }
                if (!_isBefore(selectedTime, customEndTime)) {
                  showInvalidTimeDialog(true);
                  return;
                }
                return settings.updateCustomStartTime(selectedTime);
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
                if (selectedTime == null) {
                  return;
                }
                if (!_isAfter(selectedTime, customStartTime)) {
                  showInvalidTimeDialog(false);
                  return;
                }
                return settings.updateCustomEndTime(selectedTime);
              },
            ),
          ],
        ),
      ),
    );
  }
}
