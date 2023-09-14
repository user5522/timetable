import 'package:flutter/material.dart';

class TimeConfig extends StatelessWidget {
  final bool occupied;
  final ValueNotifier<TimeOfDay> startTime;
  final ValueNotifier<TimeOfDay> endTime;

  const TimeConfig({
    super.key,
    required this.occupied,
    required this.startTime,
    required this.endTime,
  });

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

    if (selectedTime != null &&
        (isStartTime ? selectedTime.hour < 8 : selectedTime.hour > 18)) {
      // ignore: use_build_context_synchronously
      _showInvalidTimePeriodDialog(context);
    } else if (isStartTime && selectedTime != null) {
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

  void _showInvalidTimePeriodDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Invalid Time'),
        content: const Text(
          'Time period must be between 8:00 and 18:00.',
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
    return Row(
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
    );
  }
}
