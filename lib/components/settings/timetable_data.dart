import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:timetable/components/widgets/alert_dialog.dart';
import 'package:timetable/provider/subjects.dart';

/// All the settings that allow for manipulating the timetable's data.
class TimetableDataOptions extends ConsumerWidget {
  const TimetableDataOptions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subjNotifier = ref.watch(subjProvider.notifier);

    return Column(
      children: [
        ListTile(
          onTap: () async {
            showDialog<void>(
              context: context,
              barrierDismissible: true,
              builder: (BuildContext context) {
                return ShowAlertDialog(
                  content: const Text("Delete all Subjects?"),
                  approveButtonText: "Delete",
                  onApprove: () {
                    subjNotifier.resetData();
                    Navigator.of(context).pop();
                  },
                );
              },
            );
          },
          title: const Text("Remove All Subjects"),
        ),
      ],
    );
  }
}
