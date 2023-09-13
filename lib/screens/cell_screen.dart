import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:timetable/components/cell_screen_configs/colors_config.dart';
import 'package:timetable/components/cell_screen_configs/day_time_config.dart';
import 'package:timetable/components/widgets/list_tile_group.dart';
import 'package:timetable/constants/days.dart';
import 'package:timetable/models/subjects.dart';

class CellScreen extends HookConsumerWidget {
  final int? rowIndex;
  final int? columnIndex;
  final Subject? subject;

  const CellScreen({
    super.key,
    this.rowIndex,
    this.columnIndex,
    this.subject,
  });

  static final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isSubjectNull = subject == null;
    final startTime = useState(
      TimeOfDay(
        hour: isSubjectNull ? (rowIndex! + 8) : subject!.startTime.hour,
        minute: 0,
      ),
    );
    final endTime = useState(
      TimeOfDay(
        hour: isSubjectNull ? (rowIndex! + 8 + 1) : subject!.endTime.hour,
        minute: 0,
      ),
    );
    const List<Days> days = Days.values;
    final state = ref.read(subjectProvider.notifier);
    final day = useState(
        Days.values[isSubjectNull ? columnIndex! : subject!.day.index]);
    final color = useState(isSubjectNull ? Colors.black : subject!.color);

    final label = useState(subject?.label ?? "");
    final location = useState(subject?.location ?? "");

    final Subject newSubject = Subject(
      label: label.value,
      location: location.value,
      color: color.value,
      startTime: startTime.value,
      endTime: endTime.value,
      day: day.value,
    );

    final subjectsInSameDay = ref
        .watch(subjectProvider)
        .where(
          (e) => e.day == day.value,
        )
        .toList();

    final isOccupied = subjectsInSameDay.any((e) {
      final eHours = List.generate(
        e.endTime.hour - e.startTime.hour,
        (index) => index + e.startTime.hour,
      );
      final inputHours = List.generate(
        endTime.value.hour - startTime.value.hour,
        (index) => index + startTime.value.hour,
      );

      return eHours.any((hour) => inputHours.contains(hour));
    });

    final isOccupiedExceptSelf =
        subjectsInSameDay.where((e) => e != subject).any((e) {
      final eHours = List.generate(
        e.endTime.hour - e.startTime.hour,
        (index) => index + e.startTime.hour,
      );
      final inputHours = List.generate(
        endTime.value.hour - startTime.value.hour,
        (index) => index + startTime.value.hour,
      );

      return eHours.any((hour) => inputHours.contains(hour));
    });

    return Scaffold(
      appBar: AppBar(
        actions: [
          if (!isSubjectNull)
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shadowColor: Colors.transparent,
                backgroundColor: Theme.of(context).colorScheme.error,
                foregroundColor: Theme.of(context).colorScheme.errorContainer,
              ),
              onPressed: () {
                state.removeSubject(subject!);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Subject Deleted!'),
                  ),
                );
                Navigator.pop(context);
              },
              child: const Text("Delete"),
            ),
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
                  if (isSubjectNull) {
                    if (isOccupied == false) {
                      state.addSubject(newSubject);
                      Navigator.pop(context, label.value);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Time slots are already occupied!'),
                        ),
                      );
                    }
                  } else {
                    if (isOccupiedExceptSelf == false) {
                      state.updateSubject(subject!, newSubject);
                      Navigator.pop(context, label.value);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Time slots are already occupied!'),
                        ),
                      );
                    }
                  }
                }
              },
              child: Text(isSubjectNull ? "Create" : "Save"),
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
                        initialValue: location.value,
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
                  occupied: isSubjectNull ? isOccupied : isOccupiedExceptSelf,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
