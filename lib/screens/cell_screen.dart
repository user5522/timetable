import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:timetable/components/cell_screen_configs/colors_config.dart';
import 'package:timetable/components/cell_screen_configs/day_time_config.dart';
import 'package:timetable/components/widgets/list_tile_group.dart';
import 'package:timetable/constants/days.dart';
import 'package:timetable/models/subjects.dart';

class CellScreen extends HookConsumerWidget {
  final int rowIndex;
  final int columnIndex;

  const CellScreen({
    super.key,
    required this.rowIndex,
    required this.columnIndex,
  });

  static final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final startTime = useState(TimeOfDay(hour: rowIndex + 8, minute: 0));
    final endTime = useState(TimeOfDay(hour: rowIndex + 8 + 1, minute: 0));
    const List<Days> days = Days.values;
    final state = ref.read(subjectProvider.notifier);
    final day = useState(Days.values[columnIndex]);
    final color = useState(Colors.black);

    final label = useState("");
    final location = useState("");

    final subjectWithSameDay = ref
        .watch(subjectProvider)
        .where(
          (element) => element.day == day.value,
        )
        .toList();

    final isOccupied = subjectWithSameDay.any((e) {
      final eHours = List.generate(e.endTime.hour - e.startTime.hour,
          (index) => index + e.startTime.hour);
      final inputHours = List.generate(
          endTime.value.hour - startTime.value.hour,
          (index) => index + startTime.value.hour);

      return eHours.any((hour) => inputHours.contains(hour));
    });

    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shadowColor: Colors.transparent,
                backgroundColor:
                    Theme.of(context).colorScheme.onPrimaryContainer,
                foregroundColor:
                    Theme.of(context).colorScheme.secondaryContainer,
              ),
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  if (isOccupied == false) {
                    state.addSubject(
                      Subject(
                        label: label.value,
                        location: location.value,
                        color: color.value,
                        startTime: startTime.value,
                        endTime: endTime.value,
                        day: day.value,
                      ),
                    );
                    Navigator.pop(context, label);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Time slots are already occupied!'),
                      ),
                    );
                  }
                }
              },
              child: const Text("Create"),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTileGroup(
                  children: [
                    ListItem(
                      title: TextFormField(
                        initialValue: label.value,
                        decoration: const InputDecoration(
                          hintText: "Subject",
                          border: InputBorder.none,
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter a Subject.';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          label.value = value;
                        },
                      ),
                    ),
                    ListItem(
                      title: TextFormField(
                        decoration: const InputDecoration(
                          hintText: "Location",
                          border: InputBorder.none,
                        ),
                        onChanged: (value) {
                          location.value = value;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                ColorsConfig(color: color),
                const SizedBox(
                  height: 10,
                ),
                TimeDayConfig(
                  day: day,
                  days: days,
                  startTime: startTime,
                  endTime: endTime,
                  occupied: isOccupied,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
