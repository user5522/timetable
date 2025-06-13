import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:timetable/features/settings/widgets/language_options.dart';
import 'package:timetable/features/settings/screens/choose_app_color.dart';
import 'package:timetable/features/settings/widgets/theme_options.dart';
import 'package:timetable/shared/widgets/color_indicator.dart';
import 'package:timetable/core/utils/get_os_version.dart';
import 'package:timetable/shared/providers/language.dart';
import 'package:timetable/features/settings/providers/settings.dart';
import 'package:timetable/shared/providers/themes.dart';

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
          leading: const Icon(Icons.translate, size: 20),
          horizontalTitleGap: 8,
          title: LanguageOptions(language: language),
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(Icons.palette_outlined, size: 20),
          horizontalTitleGap: 8,
          title: ThemeOptions(theme: theme),
          onTap: () {},
        ),
        FutureBuilder<int>(
          future: getAndroidVersion(),
          builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
            final version = snapshot.data;

            if (version != null && version >= 31) {
              return SwitchListTile(
                secondary: const Icon(Icons.wallpaper_outlined, size: 20),
                // this is dumb.. I couldn't find a better way to change the gap size on switch list tiles
                visualDensity: const VisualDensity(horizontal: -4),
                title: const Text("monet_theming").tr(),
                subtitle: const Text("Android 12+"),
                value: monetTheming,
                onChanged: (bool value) => settings.updateMonetThemeing(value),
              );
            }
            return Container();
          },
        ),
        ListTile(
          enabled: !monetTheming,
          leading: const Icon(Icons.colorize_outlined, size: 20),
          horizontalTitleGap: 8,
          title: const Text("app_color").tr(),
          trailing: ColorIndicator(
            color: appThemeColor,
            inactive: monetTheming,
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ChooseAppColor()),
            );
          },
        )
      ],
    );
  }
}
