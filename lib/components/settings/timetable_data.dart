import 'package:easy_localization/easy_localization.dart';
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

    void pop() {
      return Navigator.of(context).pop();
    }

    return Column(
      children: [
        ListTile(
          leading: const Icon(
            Icons.file_download_outlined,
            size: 20,
          ),
          horizontalTitleGap: 8,
          onTap: () {
            final ScaffoldFeatureController<SnackBar, SnackBarClosedReason>
                snackBar = ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text("create_backup_snackbar").tr(),
              ),
            );
            exportData(db, snackBar);
          },
          title: const Text("create_backup").tr(),
        ),
        ListTile(
          leading: const Icon(
            Icons.file_upload_outlined,
            size: 20,
          ),
          horizontalTitleGap: 8,
          onTap: () async {
            showDialog<void>(
              context: context,
              barrierDismissible: true,
              builder: (BuildContext context) {
                return ShowAlertDialog(
                  content: FittedBox(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("restore_backup_dialog.dialog_1").tr(),
                        const Text("restore_backup_dialog.dialog_2").tr(),
                      ],
                    ),
                  ),
                  approveButtonText: "proceed".tr(),
                  onApprove: () async {
                    await restoreData(db);
                    pop();
                  },
                );
              },
            );
          },
          title: const Text("restore_backup").tr(),
        ),
        ListTile(
          leading: const Icon(
            Icons.delete_forever_outlined,
            size: 20,
          ),
          horizontalTitleGap: 8,
          onTap: () {
            showDialog<void>(
              context: context,
              barrierDismissible: true,
              builder: (BuildContext context) {
                return ShowAlertDialog(
                  content: const Text("remove_all_subjects_dialog").tr(),
                  approveButtonText: "delete".tr(),
                  onApprove: () async {
                    await subjNotifier
                        .resetData()
                        .then((r) => Navigator.of(context).pop());
                  },
                );
              },
            );
          },
          title: const Text("remove_all_subjects").tr(),
        ),
      ],
    );
  }
}
