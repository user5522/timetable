import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:timetable/models/settings.dart';
import 'package:timetable/utilities/grid_utils.dart';

class DayViewNavigationBar extends ConsumerWidget {
  final PageController controller;

  const DayViewNavigationBar({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double screenWidth = MediaQuery.of(context).size.width;
    final hideSunday = ref.watch(settingsProvider).hideSunday;
    int daysLength = hideSunday ? days.length - 1 : days.length;

    return SizedBox(
      height: 50,
      width: screenWidth,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            color: Theme.of(context).colorScheme.background,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: daysLength,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return SizedBox(
                  width: screenWidth / daysLength,
                  child: TextButton(
                    onPressed: () {
                      controller.animateToPage(
                        index,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all<Color>(
                        Theme.of(context).colorScheme.onBackground,
                      ),
                    ),
                    child: Text(days[index][0]),
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
