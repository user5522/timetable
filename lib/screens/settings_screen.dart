import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:timetable/components/settings/customize_timetable.dart';
import 'package:timetable/components/settings/theme_options.dart';
import 'package:timetable/components/settings/timetable_data.dart';
import 'package:timetable/components/settings/timetable_features.dart';
import 'package:timetable/components/widgets/navigation_bar_toggle.dart';
import 'package:timetable/provider/settings.dart';
import 'package:timetable/provider/themes.dart';

/// Settings Screen, groups all settings ([CustomizeTimetableOptions], [TimetableDataOptions],
///  [TimetableFeaturesOptions] and [ThemeOptions]) together.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({
    super.key,
  });

  Future<int> getAndroidVersion() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    return androidInfo.version.sdkInt;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.read(themeModeProvider.notifier);
    final monetTheming = ref.watch(settingsProvider).monetTheming;
    final settings = ref.read(settingsProvider.notifier);
    final navbarToggle = ref.watch(settingsProvider).navbarVisible;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        leading: navbarToggle ? null : const NavbarToggle(),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              dense: true,
              title: const Text("General"),
              textColor: Theme.of(context).colorScheme.primary,
            ),
            ListTile(
              title: ThemeOptions(
                themeMode: themeMode,
              ),
              onTap: () {},
            ),
            FutureBuilder<AndroidDeviceInfo>(
              future: DeviceInfoPlugin().androidInfo,
              builder: (
                BuildContext context,
                AsyncSnapshot<AndroidDeviceInfo> snapshot,
              ) {
                final androidDeviceInfo = snapshot.data;

                if (androidDeviceInfo != null &&
                    androidDeviceInfo.version.sdkInt >= 31) {
                  return SwitchListTile(
                    title: const Text("Monet Theming"),
                    subtitle: const Text("Android 12+"),
                    value: monetTheming,
                    onChanged: (bool value) {
                      settings.updateMonetThemeing(value);
                    },
                  );
                }
                return Container();
              },
            ),
            ListTile(
              dense: true,
              title: const Text("Customize Timetable"),
              textColor: Theme.of(context).colorScheme.primary,
            ),
            const CustomizeTimetableOptions(),
            ListTile(
              dense: true,
              title: const Text("Timetable Features"),
              textColor: Theme.of(context).colorScheme.primary,
            ),
            const TimetableFeaturesOptions(),
            ListTile(
              dense: true,
              title: const Text("Timetable Data"),
              textColor: Theme.of(context).colorScheme.primary,
            ),
            const TimetableDataOptions(),
          ],
        ),
      ),
    );
  }
}
