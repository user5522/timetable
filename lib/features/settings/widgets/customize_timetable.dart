import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:timetable/features/settings/widgets/default_view_options.dart';
import 'package:timetable/features/settings/providers/settings.dart';

/// All the settings that allow for customizing the timetable.
class CustomizeTimetableOptions extends ConsumerWidget {
  const CustomizeTimetableOptions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.read(settingsProvider.notifier);
    final hideSunday = ref.watch(settingsProvider).hideSunday;
    final compactMode = ref.watch(settingsProvider).compactMode;
    final hideLocation = ref.watch(settingsProvider).hideLocation;
    final singleLetterDays = ref.watch(settingsProvider).singleLetterDays;
    final hideTransparentSubject =
        ref.watch(settingsProvider).hideTransparentSubject;
    final defaultTimetableView =
        ref.watch(settingsProvider).defaultTimetableView;

    final switchItems = [
      {
        'icon': Icons.close_fullscreen_outlined,
        'title': 'compact_mode',
        'value': compactMode,
        'onChanged': settings.updateCompactMode,
      },
      {
        'icon': Icons.title_outlined,
        'title': 'single_letter_days',
        'value': singleLetterDays,
        'onChanged': settings.updateSingleLetterDays,
      },
      {
        'icon': Icons.location_off_outlined,
        'title': 'hide_locations',
        'value': hideLocation,
        'onChanged': settings.updateHideLocation,
      },
      {
        'icon': Icons.visibility_off_outlined,
        'title': 'hide_sunday',
        'value': hideSunday,
        'onChanged': settings.updateHideSunday,
      },
      {
        'icon': Icons.visibility_off_outlined,
        'title': 'hide_transparent_subjects',
        'value': hideTransparentSubject,
        'onChanged': settings.updateHideTransparentSubject,
      },
    ];

    return Column(
      children: [
        ListTile(
          horizontalTitleGap: 8,
          leading: const Icon(Icons.table_chart_outlined, size: 20),
          title: DefaultViewOptions(
            settings: settings,
            defaultTimetableView: defaultTimetableView,
          ),
          onTap: () {},
        ),
        ...switchItems.map(
          (item) => SwitchListTile(
            secondary: Icon(item['icon'] as IconData, size: 20),
            visualDensity: const VisualDensity(horizontal: -4),
            title: Text(item['title'] as String).tr(),
            value: item['value'] as bool,
            onChanged: item['onChanged'] as Function(bool),
          ),
        ),
      ],
    );
  }
}
