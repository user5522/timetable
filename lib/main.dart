import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:timetable/components/widgets/navigation_bar.dart';
import 'package:timetable/constants/theme_options.dart';
import 'package:timetable/models/settings.dart';
import 'package:timetable/models/subjects.dart';
import 'package:timetable/provider/themes.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(TimeOfDayAdapter());
  Hive.registerAdapter(DaysAdapter());
  Hive.registerAdapter(RotationWeeksAdapter());
  Hive.registerAdapter(SubjectAdapter());
  runApp(
    const ProviderScope(
      child: Timetable(),
    ),
  );
}

/// The main class of the application.
class Timetable extends ConsumerWidget {
  const Timetable({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final monetTheming = ref.watch(settingsProvider).monetTheming;
    final Brightness systemBrightness =
        MediaQuery.of(context).platformBrightness;

    return DynamicColorBuilder(
      builder: (
        ColorScheme? lightDynamic,
        ColorScheme? darkDynamic,
      ) {
        return MaterialApp(
          title: 'Timetable',
          color: Colors.white,
          theme: ThemeData(
            colorScheme: monetTheming
                ? themeMode == ThemeModeOption.auto
                    ? systemBrightness == Brightness.light
                        ? lightDynamic
                        : darkDynamic
                    : themeMode == ThemeModeOption.light
                        ? lightDynamic
                        : darkDynamic
                : ColorScheme.fromSeed(
                    seedColor: Colors.deepPurple,
                    brightness: themeMode == ThemeModeOption.auto
                        ? systemBrightness
                        : themeMode == ThemeModeOption.dark
                            ? Brightness.dark
                            : Brightness.light,
                  ),
            useMaterial3: true,
          ),
          home: Navigation(),
        );
      },
    );
  }
}
