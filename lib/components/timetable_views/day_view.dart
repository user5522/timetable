import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:timetable/components/widgets/day_view_navigation_bar.dart';
import 'package:timetable/components/widgets/day_view_subject_builder.dart';
import 'package:timetable/models/subjects.dart';
import 'package:timetable/screens/timetable_screen.dart';
import 'package:timetable/utilities/grid_utils.dart';

class TimetableDayView extends HookConsumerWidget {
  const TimetableDayView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    PageController controller;
    final subject = ref.watch(subjectProvider);

    controller = PageController(initialPage: DateTime.now().weekday - 1);

    return Column(
      children: [
        DayViewNavigationBar(
          controller: controller,
        ),
        Expanded(
          child: PageView.builder(
            itemCount: columns,
            pageSnapping: true,
            controller: controller,
            itemBuilder: (context, index) {
              int startDay = ((DateTime.monday + index - 1) % 7 + 1);

              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        days[startDay - 1],
                        style: const TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 20,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: subject
                            .where((s) => s.day.index == index)
                            .map(
                              (subject) => DayViewSubjectBuilder(
                                subject: subject,
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}