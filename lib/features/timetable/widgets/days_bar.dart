import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:timetable/core/constants/days.dart';
import 'package:timetable/core/constants/grid_properties.dart';
import 'package:timetable/core/constants/theme_options.dart';
import 'package:timetable/features/settings/providers/settings.dart';
import 'package:timetable/shared/providers/day.dart';
import 'package:timetable/shared/providers/themes.dart';

/// Top navigation bar in the day view that allows to switch between days quickly
/// also acts as the days row in the grid view.
class DaysBar extends ConsumerWidget {
  final PageController controller;
  final bool? isGridView;

  const DaysBar({
    super.key,
    required this.controller,
    this.isGridView = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double screenWidth = MediaQuery.of(context).size.width;
    final singleLetterDays = ref.watch(settingsProvider).singleLetterDays;
    final bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    final theme = ref.watch(themeProvider);
    final Brightness systemBrightness =
        MediaQuery.of(context).platformBrightness;
    final darkCurrentDayColorScheme =
        Theme.of(context).colorScheme.onInverseSurface;
    final lightCurrentDayColorScheme =
        Theme.of(context).colorScheme.outlineVariant;
    final days = ref.watch(orderedDaysProvider);
    final currentDay = ref.watch(currentDayIndexProvider);

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
              itemCount: days.length,
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
                  daysLength: days.length,
                  screenWidth: screenWidth,
                  orderedDays: days,
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
    required List<Day> orderedDays,
  }) {
    if (index == -1) return const SizedBox.shrink();
    final isCurrentDay = isGridView && (currentDay == index);
    final day = orderedDays[index];

    final dayText = singleLetterDays
        ? day.initial.tr()
        : isPortrait
            ? day.name.tr().substring(0, 3)
            : day.name.tr();

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
    final currentDay = ref.watch(currentDayIndexProvider);

    useEffect(() {
      final timer = Timer.periodic(const Duration(minutes: 1), (_) {
        final newDay = ref.read(dayServiceProvider).currentDayIndex;
        if (newDay != currentDay) {
          ref.read(currentDayIndexProvider.notifier).state = newDay;
        }
      });
      return timer.cancel;
    }, []);

    return DaysBar(
      controller: controller,
      isGridView: isGridView,
    );
  }
}
