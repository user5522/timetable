import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:timetable/db/database.dart';
import 'package:timetable/provider/timetables.dart';

/// Toggles between all Timetables.
///
/// used for filtering
class TimetableToggle extends HookConsumerWidget {
  final ValueNotifier<TimetableData> timetable;
  const TimetableToggle({
    super.key,
    required this.timetable,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timetables = ref.watch(timetableProvider);
    final clickCount = useState(0);

    void increment() {
      clickCount.value++;
      if (clickCount.value >= timetables.length) {
        clickCount.value = 0;
      }
    }

    return InkWell(
      onTap: () {
        increment();
        timetable.value = timetables[clickCount.value];
      },
      borderRadius: BorderRadius.circular(50),
      child: Ink(
        width: 40,
        height: 40,
        child: Center(
          child: Text(
            timetables[clickCount.value].name[0],
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
