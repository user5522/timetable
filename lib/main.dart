import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:timetable/components/widgets/eager_initilization.dart';
import 'package:timetable/components/widgets/bottom_navigation_bar.dart';
import 'package:timetable/constants/languages.dart';
import 'package:timetable/constants/theme_options.dart';
import 'package:timetable/provider/settings.dart';
import 'package:timetable/provider/themes.dart';
import 'package:easy_localization/easy_localization.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  EasyLocalization.logger.enableLevels = [];

  runApp(
    ProviderScope(
      child: EasyLocalization(
        supportedLocales: languages,
        path: 'assets/translations',
        fallbackLocale: languages[0],
        child: const TimetableApp(),
      ),
    ),
  );
}

/// The main class of the application.
class TimetableApp extends ConsumerWidget {
  const TimetableApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeProvider);
    final monetTheming = ref.watch(settingsProvider).monetTheming;
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
            colorScheme: monetTheming
                ? theme == ThemeOption.auto
                    ? systemBrightness == Brightness.light
                        ? lightDynamic
                        : darkDynamic
                    : theme == ThemeOption.light
                        ? lightDynamic
                        : darkDynamic
                : ColorScheme.fromSeed(
                    seedColor: Colors.deepPurple,
                    brightness: theme == ThemeOption.auto
                        ? systemBrightness
                        : theme == ThemeOption.dark
                            ? Brightness.dark
                            : Brightness.light,
                  ),
            useMaterial3: true,
          ),
          home: const EagerInitialization(
            child: BottomNavigation(),
          ),
        );
      },
    );
  }
}
