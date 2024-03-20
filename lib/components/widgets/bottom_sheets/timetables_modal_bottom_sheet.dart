import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:timetable/components/widgets/subject_data_bottom_sheet.dart';
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
      child: SubjectDataBottomSheet(
        title: "timetable".plural(2),
        children: timetables.map(
          (t) {
            return ListTile(
              title: Text("${"timetable".plural(1)} ${t.name}"),
              visualDensity: VisualDensity.compact,
              onTap: () {
                timetable.value = t;
                Navigator.pop(context);
              },
            );
          },
        ).toList(),
      ),
    );
  }
}
