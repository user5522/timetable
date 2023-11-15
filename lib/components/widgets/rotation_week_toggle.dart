import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:timetable/constants/rotation_weeks.dart';

/// Toggles between all rotation weeks.
class RotationWeekToggle extends HookWidget {
  final ValueNotifier<RotationWeeks> rotationWeek;
  const RotationWeekToggle({
    Key? key,
    required this.rotationWeek,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final clickCount = useState(0);
    List<RotationWeeks> labels = [
      RotationWeeks.all,
      RotationWeeks.a,
      RotationWeeks.b,
    ];

    void changeLabel() {
      clickCount.value++;
      if (clickCount.value >= 3) {
        clickCount.value = 0;
      }
    }

    return InkWell(
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
    );
  }
}
