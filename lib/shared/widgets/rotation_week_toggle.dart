import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:timetable/core/constants/rotation_weeks.dart';
import 'package:timetable/core/utils/rotation_weeks.dart';
import 'package:timetable/core/utils/subjects.dart';

/// Toggles between all rotation weeks.
///
/// used for filtering.
class RotationWeekToggle extends HookWidget {
  final ValueNotifier<RotationWeeks> rotationWeek;
  const RotationWeekToggle({
    super.key,
    required this.rotationWeek,
  });

  @override
  Widget build(BuildContext context) {
    final clickCount = useState(0);
    List<RotationWeeks> labels = [
      RotationWeeks.all,
      RotationWeeks.a,
      RotationWeeks.b,
    ];

    return InkWell(
      onTap: () {
        increment(clickCount, labels.length);
        rotationWeek.value = labels[clickCount.value];
      },
      borderRadius: BorderRadius.circular(50),
      child: Ink(
        width: 40,
        height: 40,
        child: Center(
          child: Text(
            getRotationWeekButtonLabel(labels[clickCount.value]),
            overflow: TextOverflow.clip,
            softWrap: false,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
