import 'package:device_info_plus/device_info_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:timetable/components/settings/language_options.dart';
import 'package:timetable/components/settings/theme_options.dart';
import 'package:timetable/provider/language.dart';
import 'package:timetable/provider/settings.dart';
import 'package:timetable/provider/themes.dart';

class GeneralOptions extends ConsumerWidget {
  const GeneralOptions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.read(themeModeProvider.notifier);
    final language = ref.read(languageProvider.notifier);
    final monetTheming = ref.watch(settingsProvider).monetTheming;
    final settings = ref.read(settingsProvider.notifier);

    return Column(
      children: [
        ListTile(
          title: LanguageOptions(
            language: language,
          ),
          onTap: () {},
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
                title: const Text("monet_theming").tr(),
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
      ],
    );
  }
}
