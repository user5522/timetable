import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:timetable/core/constants/days.dart';
import 'package:timetable/features/settings/providers/settings.dart';

/// Week starting day options dropdown menu.
class WeekStartDayOptions extends StatelessWidget {
  final SettingsNotifier settings;
  final int defaultWeekStartDay;

  const WeekStartDayOptions({
    super.key,
    required this.settings,
    required this.defaultWeekStartDay,
  });

  @override
  Widget build(BuildContext context) {
    List<DropdownMenuEntry<int>> weekStartDaysEntries() {
      final entries = <DropdownMenuEntry<int>>[];
      const options = 2;

      for (int i = 0; i < options; i++) {
        final day = Day.values[i];
        final label = day.name.tr();

        entries.add(
          DropdownMenuEntry<int>(value: i, label: label),
        );
      }

      return entries.toList();
    }

    return Row(
      children: [
        const Text('week_start_day').tr(),
        const Spacer(),
        DropdownMenu<int>(
          // this is needed to change the initial selection with the new locale
          key: ValueKey(context.locale),
          width: 130,
          dropdownMenuEntries: weekStartDaysEntries(),
          label: const Text("day").plural(1),
          initialSelection: defaultWeekStartDay,
          onSelected: (value) {
            settings.updateWeekStartDay(value!);
          },
        ),
      ],
    );
  }
}
