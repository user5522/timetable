import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:timetable/components/timetable_views/day_view.dart';
import 'package:timetable/components/timetable_views/grid_view.dart';
import 'package:timetable/components/widgets/grid_day_views_toggle.dart';
import 'package:timetable/components/widgets/navigation_bar_toggle.dart';
import 'package:timetable/components/widgets/rotation_week_toggle.dart';
import 'package:timetable/constants/rotation_weeks.dart';
import 'package:timetable/models/settings.dart';

/// The main screen, displays the default timetable view.
/// basically groups [TimetableGridView] & [TimetableDayView].
class TimetableScreen extends HookConsumerWidget {
  const TimetableScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rotationWeeks = ref.watch(settingsProvider).rotationWeeks;
    final isGridView = useState(true);
    final rotationWeek = useState(RotationWeeks.all);

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            NavbarToggle(),
            SizedBox(
              width: 5,
            ),
            Text('Timetable'),
          ],
        ),
        actions: [
          if (rotationWeeks)
            RotationWeekToggle(
              rotationWeek: rotationWeek,
            ),
          GridDayViewsToggle(
            isGridView: isGridView,
          ),
        ],
      ),
      body: isGridView.value
          ? TimetableGridView(
              rotationWeek: rotationWeek,
            )
          : TimetableDayView(
              rotationWeek: rotationWeek,
            ),
    );
  }
}
