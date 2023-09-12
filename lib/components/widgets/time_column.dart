import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:timetable/constants/grid_properties.dart';
import 'package:timetable/models/settings.dart';
import 'package:timetable/utilities/grid_utils.dart';

class TimeColumn extends ConsumerWidget {
  const TimeColumn({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final compactMode = ref.watch(settingsProvider).compactMode;

    return Column(
      children: List.generate(
        10,
        (i) => Container(
          alignment: Alignment.topCenter,
          height: compactMode ? 125 : 100,
          width: timeColumnWidth,
          child: Text(
            times24h[i + (8 - 1)],
            style: const TextStyle(fontSize: 13),
          ),
        ),
      ),
    );
  }
}
