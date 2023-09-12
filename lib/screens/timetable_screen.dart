import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:timetable/components/timetable_views/day_view.dart';
import 'package:timetable/components/timetable_views/grid_view.dart';

class TimetablePage extends HookWidget {
  const TimetablePage({super.key});

  @override
  Widget build(BuildContext context) {
    final isGridView = useState(true);

    return Scaffold(
      appBar: AppBar(title: const Text('Timetable'), actions: [
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
          ? const TimetableGridView()
          : const TimetableDayView(),
    );
  }
}
