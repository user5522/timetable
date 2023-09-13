import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:timetable/components/timetable_views/day_view.dart';
import 'package:timetable/components/timetable_views/grid_view.dart';
import 'package:timetable/constants/rotation_weeks.dart';
import 'package:timetable/models/settings.dart';

class TimetablePage extends HookConsumerWidget {
  const TimetablePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rotationWeeks = ref.watch(settingsProvider).rotationWeeks;
    final isGridView = useState(true);
    final rotationWeek = useState(RotationWeeks.all);

    List<RotationWeeks> labels = [
      RotationWeeks.all,
      RotationWeeks.a,
      RotationWeeks.b
    ];
    final clickCount = useState(0);

    void changeLabel() {
      clickCount.value++;
      if (clickCount.value >= 3) {
        clickCount.value = 0;
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Timetable'), actions: [
        if (rotationWeeks)
          InkWell(
            onTap: () {
              changeLabel();
              rotationWeek.value = labels[clickCount.value];
            },
            borderRadius: BorderRadius.circular(50),
            child: Ink(
              width: 40,
              height: 40,
              child: Center(
                child: Text(
                  getRotationWeekButtonLabel(labels[clickCount.value]),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        IconButton(
          onPressed: () {
            isGridView.value = !isGridView.value;
          },
          selectedIcon: const Icon(Icons.view_agenda_outlined),
          icon: const Icon(Icons.grid_view_outlined),
          isSelected: isGridView.value,
        )
      ]),
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
