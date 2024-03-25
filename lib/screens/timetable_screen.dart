import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:timetable/components/timetable_views/day_view.dart';
import 'package:timetable/components/timetable_views/grid_view.dart';
import 'package:timetable/components/widgets/days_bar.dart';
import 'package:timetable/components/widgets/grid_day_views_toggle.dart';
import 'package:timetable/components/widgets/navigation_bar_toggle.dart';
import 'package:timetable/components/widgets/rotation_week_toggle.dart';
import 'package:timetable/components/widgets/timetable_toggle.dart';
import 'package:timetable/constants/rotation_weeks.dart';
import 'package:timetable/constants/timetable_views.dart';
import 'package:timetable/provider/settings.dart';
import 'package:timetable/provider/subjects.dart';
import 'package:timetable/provider/timetables.dart';

/// The main screen, displays the default timetable view.
/// basically groups [TimetableGridView] & [TimetableDayView].
class TimetableScreen extends HookConsumerWidget {
  const TimetableScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rotationWeeks = ref.watch(settingsProvider).rotationWeeks;
    final multipleTimetables = ref.watch(settingsProvider).multipleTimetables;
    final defaultTimetableView =
        ref.watch(settingsProvider).defaultTimetableView;
    final timetables = ref.watch(timetableProvider);
    final isGridView = useState(defaultTimetableView == TbViews.grid);
    final rotationWeek = useState(RotationWeeks.all);

    final subject = ref.watch(subjectProvider);
    final currentTimetable = useState(timetables[0]);
    final PageController controller;
    controller = PageController(initialPage: DateTime.now().weekday - 1);

    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: isGridView.value ? null : 0.0,
        leading: const NavbarToggle(),
        title: const Text('timetable').plural(1),
        actions: [
          if (multipleTimetables && (timetables.length > 1))
            TimetableToggle(
              timetable: currentTimetable,
            ),
          if (rotationWeeks)
            RotationWeekToggle(
              rotationWeek: rotationWeek,
            ),
          GridDayViewsToggle(
            isGridView: isGridView,
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48.0),
          child: DayBarUpdater(
            controller: controller,
            isGridView: isGridView.value,
          ),
        ),
      ),
      body: isGridView.value
          ? TimetableGridView(
              rotationWeek: rotationWeek,
              subject: subject,
              currentTimetable: currentTimetable,
            )
          : TimetableDayView(
              rotationWeek: rotationWeek,
              subject: subject,
              currentTimetable: currentTimetable,
              controller: controller,
            ),
    );
  }
}
