import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:timetable/db/database.dart';
import 'package:timetable/provider/timetables.dart';

/// Bottom Sheet Modal Widget used to select a subject's timetable.
class TimetablesModalBottomSheet extends ConsumerWidget {
  final ValueNotifier<TimetableData?> timetable;

  const TimetablesModalBottomSheet({
    super.key,
    required this.timetable,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timetables = ref.watch(timetableProvider);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 15.0),
            child: Text(
              "Timetables",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          ListView(
            shrinkWrap: true,
            primary: false,
            children: timetables.map(
              (t) {
                return ListTile(
                  title: Text("Timetable ${t.name}"),
                  visualDensity: VisualDensity.compact,
                  onTap: () {
                    timetable.value = t;
                    Navigator.pop(context);
                  },
                );
              },
            ).toList(),
          ),
        ],
      ),
    );
  }
}
