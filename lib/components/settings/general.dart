import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:timetable/components/settings/language_options.dart';
import 'package:timetable/components/settings/screens/choose_app_color.dart';
import 'package:timetable/components/settings/theme_options.dart';
import 'package:timetable/components/widgets/color_indicator.dart';
import 'package:timetable/helpers/get_os_version.dart';
import 'package:timetable/provider/language.dart';
import 'package:timetable/provider/settings.dart';
import 'package:timetable/provider/themes.dart';

/// All the general app settings (mostly appearance).
class GeneralOptions extends ConsumerWidget {
  const GeneralOptions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.read(themeProvider.notifier);
    final language = ref.read(languageProvider.notifier);
    final monetTheming = ref.watch(settingsProvider).monetTheming;
    final appThemeColor = ref.watch(settingsProvider).appThemeColor;
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
            theme: theme,
          ),
          onTap: () {},
        ),
        FutureBuilder<int>(
          future: getAndroidVersion(),
          builder: (
            BuildContext context,
            AsyncSnapshot<int> snapshot,
          ) {
            final version = snapshot.data;

            if (version != null && version >= 31) {
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
        ListTile(
          enabled: !monetTheming,
          title: Row(
            children: [
              const Text("app_color").tr(),
              const Spacer(),
              Opacity(
                opacity: !monetTheming ? 1 : .5,
                child: ColorIndicator(color: appThemeColor),
              ),
            ],
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ChooseAppColor(),
              ),
            );
          },
        )
      ],
    );
  }
}
