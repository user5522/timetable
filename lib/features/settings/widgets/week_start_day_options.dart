import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:timetable/core/constants/days.dart';
import 'package:timetable/features/settings/providers/settings.dart';

/// Week starting day options dropdown menu.
class WeekStartDayOptions extends HookConsumerWidget {
  final SettingsNotifier settings;
  final int defaultWeekStartDay;

  const WeekStartDayOptions({
    super.key,
    required this.settings,
    required this.defaultWeekStartDay,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsState = ref.watch(settingsProvider);
    final hideSunday = settingsState.hideSunday;
    final weekStartDay = settingsState.weekStartDay;

    useEffect(() {
      if (hideSunday && weekStartDay == 0) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          settings.updateWeekStartDay(1);
        });
      }
      return null;
    }, [hideSunday, weekStartDay]);

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
          enabled: !hideSunday,
          dropdownMenuEntries: weekStartDaysEntries(),
          label: const Text("day").plural(1),
          initialSelection: hideSunday ? 1 : weekStartDay,
          onSelected: (value) {
            settings.updateWeekStartDay(value!);
          },
        ),
      ],
    );
  }
}
