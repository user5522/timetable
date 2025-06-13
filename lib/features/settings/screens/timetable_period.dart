import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:timetable/core/utils/time_formatter.dart';
import 'package:timetable/core/utils/time_management.dart';
import 'package:timetable/features/settings/providers/settings.dart';

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

    final uses24HoursFormat = MediaQuery.of(context).alwaysUse24HourFormat;

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

    Future<void> handleTimeSelection(
      TimeOfDay currentTime,
      TimeOfDay otherTime,
      bool isStartTime,
    ) async {
      final selectedTime = await timePicker(
        context: context,
        time: isStartTime ? customStartTime : customEndTime,
      );
      if (selectedTime == null) return;

      if (selectedTime.hour == otherTime.hour) {
        showInvalidEqualTimeDialog();
        return;
      }

      if (isStartTime && selectedTime.isAfter(otherTime)) {
        switchStartWithEndTime(selectedTime);
      } else if (!isStartTime && selectedTime.isBefore(otherTime)) {
        switchEndWithStartTime(selectedTime);
      } else {
        isStartTime
            ? settings.updateCustomStartTime(selectedTime)
            : settings.updateCustomEndTime(selectedTime);
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text("period_preferences").tr()),
      body: ListView(
        children: [
          buildSwitchListTile(
            icon: Icons.edit_outlined,
            titleKey: "custom_time_period",
            value: customTimePeriod,
            onChanged: (value) {
              settings.updateCustomTimePeriod(value);
              if (twentyFourHours) settings.update24Hours(!value);
            },
          ),
          buildSwitchListTile(
            icon: Icons.schedule_outlined,
            titleKey: "24_hour_period",
            value: twentyFourHours,
            onChanged: (value) {
              settings.update24Hours(value);
              if (customTimePeriod) settings.updateCustomTimePeriod(false);
            },
          ),
          ListTile(
            dense: true,
            title: const Text("configuration").tr(),
            enabled: customTimePeriod,
            textColor: Theme.of(context).colorScheme.primary,
          ),
          buildTimeListTile(
            icon: Icons.play_arrow_outlined,
            titleKey: "start_time",
            time: customStartTime,
            enabled: customTimePeriod,
            getTime: TimeFormatter.getTime,
            uses24HoursFormat: uses24HoursFormat,
            onTap: () =>
                handleTimeSelection(customStartTime, customEndTime, true),
          ),
          buildTimeListTile(
            icon: Icons.stop_outlined,
            titleKey: "end_time",
            time: customEndTime,
            enabled: customTimePeriod,
            getTime: TimeFormatter.getTime,
            uses24HoursFormat: uses24HoursFormat,
            onTap: () =>
                handleTimeSelection(customEndTime, customStartTime, false),
          ),
        ],
      ),
    );
  }

  Widget buildSwitchListTile({
    required IconData icon,
    required String titleKey,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      secondary: Icon(icon, size: 20),
      visualDensity: const VisualDensity(horizontal: -4),
      title: Text(titleKey).tr(),
      value: value,
      onChanged: onChanged,
    );
  }

  Widget buildTimeListTile({
    required IconData icon,
    required String titleKey,
    required TimeOfDay time,
    required bool enabled,
    required VoidCallback onTap,
    required bool uses24HoursFormat,
    required String Function(TimeOfDay time, bool uses24HoursFormat) getTime,
  }) {
    return ListTile(
      leading: Icon(icon, size: 20),
      horizontalTitleGap: 8,
      title: Text(titleKey).tr(),
      enabled: enabled,
      subtitle: Text(getTime(time, uses24HoursFormat)),
      onTap: enabled ? onTap : null,
    );
  }
}
