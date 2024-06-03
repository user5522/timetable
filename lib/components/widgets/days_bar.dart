import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:timetable/constants/days.dart';
import 'package:timetable/constants/grid_properties.dart';
import 'package:timetable/provider/settings.dart';

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
                return SizedBox(
                  width: isGridView!
                      ? ((screenWidth - (timeColumnWidth - 1)) / daysLength)
                      : (screenWidth / daysLength),
                  child: TextButton(
                    onPressed: () {
                      if (isGridView!) return;

                      controller.animateToPage(
                        index,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    style: ButtonStyle(
                      foregroundColor: WidgetStateProperty.all<Color>(
                        Theme.of(context).colorScheme.onSurface,
                      ),
                      backgroundColor: isGridView! && (currentDay == index)
                          ? WidgetStateProperty.all<Color>(
                              Theme.of(context)
                                  .colorScheme
                                  .surfaceContainerHighest,
                            )
                          : null,
                    ),
                    child: Text(
                      overflow: TextOverflow.clip,
                      softWrap: false,
                      singleLetterDays
                          ? days[index].tr()[0]
                          : isPortrait
                              ? days[index].tr().substring(0, 3)
                              : days[index].tr(),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class DayBarUpdater extends StatefulWidget {
  final PageController controller;
  final bool isGridView;

  const DayBarUpdater({
    super.key,
    required this.controller,
    required this.isGridView,
  });

  @override
  State<DayBarUpdater> createState() => _DayBarUpdaterState();
}

class _DayBarUpdaterState extends State<DayBarUpdater> {
  late Timer timer;
  int currentDay = DateTime.now().weekday - 1;

  @override
  void initState() {
    super.initState();
    updateTimer();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  void updateTimer() {
    final nextMidnight = DateTime(
      DateTime.now().add(const Duration(days: 1)).day,
      0,
      0,
      0,
    );
    timer = Timer(nextMidnight.difference(DateTime.now()), updateDay);
  }

  void updateDay() {
    setState(() {
      currentDay = DateTime.now().weekday - 1;
    });
    updateTimer();
  }

  @override
  Widget build(BuildContext context) {
    return DaysBar(
      controller: widget.controller,
      isGridView: widget.isGridView,
      currentDay: currentDay,
    );
  }
}
