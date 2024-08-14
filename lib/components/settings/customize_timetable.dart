import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:timetable/components/settings/default_view_options.dart';
import 'package:timetable/provider/settings.dart';

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

    return Column(
      children: [
        ListTile(
          leading: const Icon(
            Icons.table_chart_outlined,
            size: 20,
          ),
          horizontalTitleGap: 8,
          title: DefaultViewOptions(
            settings: settings,
            defaultTimetableView: defaultTimetableView,
          ),
          onTap: () {},
        ),
        SwitchListTile(
          secondary: const Icon(
            Icons.close_fullscreen_outlined,
            size: 20,
          ),
          visualDensity: const VisualDensity(horizontal: -4),
          title: const Text("compact_mode").tr(),
          value: compactMode,
          onChanged: (bool value) {
            settings.updateCompactMode(value);
          },
        ),
        SwitchListTile(
          secondary: const Icon(
            Icons.title_outlined,
            size: 20,
          ),
          visualDensity: const VisualDensity(horizontal: -4),
          title: const Text("single_letter_days").tr(),
          value: singleLetterDays,
          onChanged: (bool value) {
            settings.updateSingleLetterDays(value);
          },
        ),
        SwitchListTile(
          secondary: const Icon(
            Icons.location_off_outlined,
            size: 20,
          ),
          visualDensity: const VisualDensity(horizontal: -4),
          title: const Text("hide_locations").tr(),
          value: hideLocation,
          onChanged: (bool value) {
            settings.updateHideLocation(value);
          },
        ),
        SwitchListTile(
          secondary: const Icon(
            Icons.visibility_off_outlined,
            size: 20,
          ),
          visualDensity: const VisualDensity(horizontal: -4),
          title: const Text("hide_sunday").tr(),
          value: hideSunday,
          onChanged: (bool value) {
            settings.updateHideSunday(value);
          },
        ),
        SwitchListTile(
          secondary: const Icon(
            Icons.visibility_off_outlined,
            size: 20,
          ),
          visualDensity: const VisualDensity(horizontal: -4),
          title: const Text("hide_transparent_subjects").tr(),
          value: hideTransparentSubject,
          onChanged: (bool value) {
            settings.updateHideTransparentSubject(value);
          },
        ),
      ],
    );
  }
}
