import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:timetable/shared/widgets/bottom_sheets/subject_data.dart';
import 'package:timetable/core/db/database.dart';
import 'package:timetable/features/timetable/providers/timetables.dart';

/// Bottom Sheet Modal Widget used to select a subject's timetable.
class TimetablesModalBottomSheet extends ConsumerWidget {
  final ValueNotifier<Timetable?> timetable;

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
        children: List.generate(
          timetables.length,
          (i) {
            final tb = timetables[i];
            bool isSelected = (tb == timetable.value);

            return ListTile(
              title: Row(
                children: [
                  Text("${"timetable".plural(1)} ${tb.name}"),
                  const Spacer(),
                  Visibility(
                    visible: isSelected,
                    child: const Icon(Icons.check),
                  ),
                ],
              ),
              visualDensity: VisualDensity.compact,
              onTap: () {
                timetable.value = tb;
                Navigator.pop(context);
              },
            );
          },
        ),
      ),
    );
  }
}
