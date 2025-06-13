import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:timetable/features/settings/widgets/customize_timetable.dart';
import 'package:timetable/features/settings/widgets/general.dart';
import 'package:timetable/features/settings/widgets/theme_options.dart';
import 'package:timetable/features/settings/widgets/timetable_data.dart';
import 'package:timetable/features/settings/widgets/timetable_features.dart';
import 'package:timetable/features/navigation/widgets/navigation_bar_toggle.dart';
import 'package:timetable/features/settings/providers/settings.dart';

/// Settings Screen, groups all settings ([CustomizeTimetableOptions], [TimetableDataOptions],
///  [TimetableFeaturesOptions] and [ThemeOptions]) together.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navbarToggle = ref.watch(settingsProvider).navbarVisible;

    return Scaffold(
      appBar: AppBar(
        title: const Text("settings").tr(),
        leading: navbarToggle ? null : const NavbarToggle(),
      ),
      body: ListView(
        children: [
          Column(
            children: [
              ListTile(
                dense: true,
                title: const Text("general").tr(),
                textColor: Theme.of(context).colorScheme.primary,
              ),
              const GeneralOptions(),
              ListTile(
                dense: true,
                title: const Text("customize_timetable").tr(),
                textColor: Theme.of(context).colorScheme.primary,
              ),
              const CustomizeTimetableOptions(),
              ListTile(
                dense: true,
                title: const Text("timetable_features").tr(),
                textColor: Theme.of(context).colorScheme.primary,
              ),
              const TimetableFeaturesOptions(),
              ListTile(
                dense: true,
                title: const Text("timetable_data").tr(),
                textColor: Theme.of(context).colorScheme.primary,
              ),
              const TimetableDataOptions(),
            ],
          ),
        ],
      ),
    );
  }
}
