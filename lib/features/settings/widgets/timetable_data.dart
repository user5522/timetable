import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:timetable/shared/widgets/alert_dialog.dart';
import 'package:timetable/core/db/database.dart';
import 'package:timetable/core/db/services/service.dart';
import 'package:timetable/features/subjects/providers/subjects.dart';
import 'package:timetable/features/timetable/providers/timetables.dart';

/// All the settings that allow for manipulating the timetable's data.
class TimetableDataOptions extends ConsumerWidget {
  const TimetableDataOptions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subjNotifier = ref.watch(subjectProvider.notifier);
    final tbNotifier = ref.watch(timetableProvider.notifier);
    final db = ref.watch(AppDatabase.databaseProvider);

    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.file_download_outlined, size: 20),
          horizontalTitleGap: 8,
          onTap: () async => await exportData(db),
          title: const Text("create_backup").tr(),
        ),
        ListTile(
          leading: const Icon(Icons.file_upload_outlined, size: 20),
          horizontalTitleGap: 8,
          onTap: () async {
            showDialog<void>(
              context: context,
              barrierDismissible: true,
              builder: (BuildContext context) {
                return ShowAlertDialog(
                  content: Text(
                    "${"restore_backup_dialog.dialog_1".tr()}\n${"restore_backup_dialog.dialog_2".tr()}",
                  ),
                  approveButtonText: "proceed".tr(),
                  onApprove: () async {
                    final nav = Navigator.of(context);

                    await restoreData(db).then((_) {
                      tbNotifier.checkAndLoadInitialData();
                      subjNotifier.loadSubjects();
                    });

                    nav.pop();
                  },
                );
              },
            );
          },
          title: const Text("restore_backup").tr(),
        ),
        ListTile(
          leading: const Icon(Icons.delete_forever_outlined, size: 20),
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
                    final navigator = Navigator.of(context);
                    await subjNotifier.resetData().then((_) => navigator.pop());
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
