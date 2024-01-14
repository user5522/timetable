import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:timetable/components/widgets/alert_dialog.dart';
import 'package:timetable/db/database.dart';
import 'package:timetable/db/services/service.dart';
import 'package:timetable/provider/subjects.dart';

/// All the settings that allow for manipulating the timetable's data.
class TimetableDataOptions extends ConsumerWidget {
  const TimetableDataOptions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subjNotifier = ref.watch(subjectProvider.notifier);
    final db = ref.watch(AppDatabase.databaseProvider);

    return Column(
      children: [
        ListTile(
          onTap: () {
            final ScaffoldFeatureController<SnackBar, SnackBarClosedReason>
                snackBar = ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Data exported successfully!"),
              ),
            );
            exportData(db, snackBar);
          },
          title: const Text("Create a Backup"),
        ),
        ListTile(
          onTap: () async {
            showDialog<void>(
              context: context,
              barrierDismissible: true,
              builder: (BuildContext context) {
                return ShowAlertDialog(
                  content: const Text(
                    "This will replace all current data. \n Are you sure?",
                  ),
                  approveButtonText: "Proceed",
                  onApprove: () {
                    final ScaffoldFeatureController<SnackBar,
                            SnackBarClosedReason> snackBar =
                        ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Data restored successfully!"),
                      ),
                    );
                    restoreData(db, snackBar);

                    Navigator.of(context).pop();
                  },
                );
              },
            );
          },
          title: const Text("Restore Data"),
        ),
        ListTile(
          onTap: () {
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
