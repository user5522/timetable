import 'package:dynamic_color/dynamic_color.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:timetable/features/navigation/bottom_navigation.dart';
import 'package:timetable/shared/widgets/eager_initilization.dart';
import 'package:timetable/core/utils/theme_helper.dart';
import 'package:timetable/features/settings/providers/settings.dart';
import 'package:timetable/shared/providers/themes.dart';

/// The main class of the application.
class TimetableApp extends ConsumerWidget {
  const TimetableApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeProvider);
    final monetTheming = ref.watch(settingsProvider).monetTheming;
    final appThemeColor = ref.watch(settingsProvider).appThemeColor;
    final Brightness systemBrightness =
        MediaQuery.of(context).platformBrightness;

    return DynamicColorBuilder(
      builder: (
        ColorScheme? lightDynamic,
        ColorScheme? darkDynamic,
      ) {
        return MaterialApp(
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          title: 'Timetable',
          color: Colors.white,
          theme: ThemeData(
            colorScheme: ThemeHelper.getColorScheme(
              monetTheming: monetTheming,
              theme: theme,
              systemBrightness: systemBrightness,
              lightDynamic: lightDynamic,
              darkDynamic: darkDynamic,
              appThemeColor: appThemeColor,
            ),
            useMaterial3: true,
          ),
          home: const EagerInitialization(child: BottomNavigation()),
        );
      },
    );
  }
}
