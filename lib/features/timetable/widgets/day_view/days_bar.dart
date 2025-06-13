import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:timetable/core/constants/days.dart';
import 'package:timetable/core/constants/grid_properties.dart';
import 'package:timetable/core/constants/theme_options.dart';
import 'package:timetable/features/settings/providers/settings.dart';
import 'package:timetable/shared/providers/themes.dart';

/// Top navigation bar in the day view that allows to switch between days quickly
/// merged with the days row in the grid view.
class DaysBar extends ConsumerWidget {
  final PageController controller;
  final bool? isGridView;
  final int currentDay;

  const DaysBar({
    super.key,
    required this.controller,
    this.isGridView = false,
    required this.currentDay,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double screenWidth = MediaQuery.of(context).size.width;
    final hideSunday = ref.watch(settingsProvider).hideSunday;
    final singleLetterDays = ref.watch(settingsProvider).singleLetterDays;
    int daysLength = hideSunday ? days.length - 1 : days.length;
    final bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    final theme = ref.watch(themeProvider);
    final Brightness systemBrightness =
        MediaQuery.of(context).platformBrightness;
    final darkCurrentDayColorScheme =
        Theme.of(context).colorScheme.onInverseSurface;
    final lightCurrentDayColorScheme =
        Theme.of(context).colorScheme.outlineVariant;

    return SizedBox(
      height: 48,
      width: screenWidth,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            padding: EdgeInsets.only(left: isGridView! ? 20 : 0),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: daysLength,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return buildDayButton(
                  index: index,
                  currentDay: currentDay,
                  currentDayColor: theme == ThemeOption.auto
                      ? systemBrightness == Brightness.dark
                          ? darkCurrentDayColorScheme
                          : lightCurrentDayColorScheme
                      : theme == ThemeOption.dark
                          ? darkCurrentDayColorScheme
                          : lightCurrentDayColorScheme,
                  singleLetterDays: singleLetterDays,
                  isPortrait: isPortrait,
                  isGridView: isGridView!,
                  daysLength: daysLength,
                  screenWidth: screenWidth,
                  colorScheme: Theme.of(context).colorScheme,
                  onTap: () {
                    if (isGridView!) return;

                    controller.animateToPage(
                      index,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDayButton({
    required int index,
    required bool isGridView,
    required int currentDay,
    required double screenWidth,
    required int daysLength,
    required bool singleLetterDays,
    required bool isPortrait,
    required Color currentDayColor,
    required VoidCallback? onTap,
    required ColorScheme colorScheme,
  }) {
    final isCurrentDay = isGridView && (currentDay == index);

    final dayText = singleLetterDays
        ? days[index].tr()[0]
        : isPortrait
            ? days[index].tr().substring(0, 3)
            : days[index].tr();

    return SizedBox(
      width: isGridView
          ? ((screenWidth - (timeColumnWidth - 1)) / daysLength)
          : (screenWidth / daysLength),
      child: TextButton(
        onPressed: onTap,
        style: TextButton.styleFrom(
          foregroundColor: colorScheme.onSurface,
          backgroundColor: isCurrentDay ? currentDayColor : null,
        ),
        child: Text(dayText, overflow: TextOverflow.clip, softWrap: false),
      ),
    );
  }
}

class DayBarUpdater extends HookConsumerWidget {
  final PageController controller;
  final bool isGridView;

  const DayBarUpdater({
    super.key,
    required this.controller,
    required this.isGridView,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentDay = useState(DateTime.now().weekday - 1);

    useEffect(() {
      Timer? timer;

      void updateTimer() {
        final now = DateTime.now();
        final nextMidnight = DateTime(now.year, now.month, now.day + 1);

        timer = Timer(nextMidnight.difference(now), () {
          currentDay.value = DateTime.now().weekday - 1;
          updateTimer();
        });
      }

      updateTimer();

      return () => timer?.cancel();
    }, []);

    return DaysBar(
      controller: controller,
      isGridView: isGridView,
      currentDay: currentDay.value,
    );
  }
}
