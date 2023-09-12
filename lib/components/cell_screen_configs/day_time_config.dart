import 'package:flutter/material.dart';
import 'package:timetable/components/widgets/days_modal_bottom_sheet.dart';
import 'package:timetable/components/widgets/list_tile_group.dart';
import 'package:timetable/constants/days.dart';

class TimeDayConfig extends StatelessWidget {
  final ValueNotifier<TimeOfDay> startTime;
  final ValueNotifier<TimeOfDay> endTime;
  final List<Days> days;
  final ValueNotifier<Days> day;
  final bool occupied;

  const TimeDayConfig(
      {super.key,
      required this.startTime,
      required this.endTime,
      required this.days,
      required this.day,
      required this.occupied});

  bool _isBefore(TimeOfDay time1, TimeOfDay time2) {
    return (time1.hour < time2.hour) ||
        (time1.hour == time2.hour && time1.minute < time2.minute);
  }

  bool _isAfter(TimeOfDay time1, TimeOfDay time2) {
    return (time1.hour > time2.hour) ||
        (time1.hour == time2.hour && time1.minute > time2.minute);
  }

  Future<void> _timePicker(
    BuildContext context,
    ValueNotifier<TimeOfDay> time,
    bool isStartTime,
    TimeOfDay startTime,
    TimeOfDay endTime,
  ) async {
    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour: time.value.hour,
        minute: 0,
      ),
    );

    if (isStartTime && selectedTime != null) {
      if (_isBefore(selectedTime, endTime)) {
        time.value = selectedTime;
      } else {
        isStartTime = true;
        // ignore: use_build_context_synchronously
        _showInvalidTimeDialog(context, isStartTime);
      }
    } else if (selectedTime != null) {
      if (_isAfter(selectedTime, startTime)) {
        time.value = selectedTime;
      } else {
        // ignore: use_build_context_synchronously
        _showInvalidTimeDialog(context, isStartTime);
      }
    }
  }

  void _showInvalidTimeDialog(BuildContext context, bool isStartTime) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Invalid Time'),
        content: Text(
          'The ${isStartTime ? "start" : "end"} time must be ${isStartTime ? "before" : "after"} the ${isStartTime ? "end" : "start"} time.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTileGroup(
      children: [
        ListItem(
          title: Row(
            children: [
              const Text("Day"),
              const Spacer(),
              ActionChip(
                side: BorderSide.none,
                backgroundColor: const Color(0xffbabcbe),
                onPressed: () {
                  showModalBottomSheet(
                    showDragHandle: true,
                    enableDrag: true,
                    isDismissible: true,
                    context: context,
                    builder: (context) {
                      return DaysModalBottomSheetState(
                        days: days,
                        day: day,
                      );
                    },
                  );
                },
                label: Text(
                  day.value.name[0].toUpperCase() +
                      day.value.name.substring(1).toLowerCase(),
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
        ListItem(
          title: Row(
            children: [
              const Text("Time"),
              const Spacer(),
              ActionChip(
                side: BorderSide.none,
                backgroundColor: const Color(0xffbabcbe),
                onPressed: () {
                  _timePicker(
                    context,
                    startTime,
                    true,
                    startTime.value,
                    endTime.value,
                  );
                },
                label: Text(
                  "${startTime.value.hour}:00",
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              const Icon(Icons.arrow_forward),
              const SizedBox(
                width: 10,
              ),
              ActionChip(
                side: BorderSide.none,
                backgroundColor: const Color(0xffbabcbe),
                onPressed: () {
                  _timePicker(
                      context, endTime, false, startTime.value, endTime.value);
                },
                label: Text(
                  "${endTime.value.hour}:00",
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
              if (occupied == true)
                const SizedBox(
                  width: 10,
                ),
              if (occupied == true)
                const Icon(
                  Icons.cancel,
                  color: Colors.redAccent,
                )
            ],
          ),
        ),
      ],
    );
  }
}
