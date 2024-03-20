import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:drift/drift.dart' as drift;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:timetable/components/widgets/alert_dialog.dart';
import 'package:timetable/components/widgets/list_item_group.dart';
import 'package:timetable/db/database.dart';
import 'package:timetable/provider/settings.dart';
import 'package:timetable/provider/timetables.dart';

/// Screen to manage the "multiple timetables" features.
class TimetableManagementScreen extends ConsumerWidget {
  const TimetableManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final multipleTimetables = ref.watch(settingsProvider).multipleTimetables;
    final settings = ref.read(settingsProvider.notifier);
    final timetables = ref.watch(timetableProvider);
    final timetable = ref.watch(timetableProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text("manage_timetables").tr(),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SwitchListTile(
              title: const Text("multiple_timetables").tr(),
              value: multipleTimetables,
              onChanged: (bool value) {
                settings.updateMultipleTimetables(value);
              },
            ),
            ListTile(
              title: const Text("reset").tr(),
              onTap: () {
                showDialog<void>(
                  context: context,
                  barrierDismissible: true,
                  builder: (BuildContext context) {
                    return ShowAlertDialog(
                      content: const Text("reset_timetables_dialog").tr(),
                      approveButtonText: "reset".tr(),
                      onApprove: () {
                        timetable.resetData();
                        Navigator.of(context).pop();
                      },
                    );
                  },
                );
              },
            ),
            ListTile(
              dense: true,
              title: const Text("manage").tr(),
              enabled: multipleTimetables ? true : false,
              textColor: Theme.of(context).colorScheme.primary,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 75),
              child: ListItemGroup(
                children: List.generate(
                  timetables.length,
                  (i) => ListItem(
                    title: Opacity(
                      opacity: timetables[i] != timetables[0]
                          ? multipleTimetables
                              ? 1
                              : .5
                          : 1,
                      child: Row(
                        children: [
                          Text(
                            "${"timetable".plural(1)} ${timetables[i].name}",
                          ),
                          const Spacer(),
                          if (timetables[i] != timetables[0] &&
                              multipleTimetables)
                            IconButton(
                              onPressed: () {
                                showDialog<void>(
                                  context: context,
                                  barrierDismissible: true,
                                  builder: (BuildContext context) {
                                    return ShowAlertDialog(
                                      content:
                                          const Text("delete_timetable_dialog")
                                              .tr(),
                                      approveButtonText: "delete".tr(),
                                      onApprove: () {
                                        timetable
                                            .deleteTimetable(timetables[i]);
                                        Navigator.of(context).pop();
                                      },
                                    );
                                  },
                                );
                              },
                              icon: const Icon(Icons.delete_outline),
                              tooltip: "delete".tr(),
                            ),
                        ],
                      ),
                    ),
                    onTap: () {},
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Visibility(
        visible: timetables.length < 5 && multipleTimetables,
        child: FloatingActionButton(
          onPressed: () {
            if (timetables.length < 5 && multipleTimetables) {
              timetable.addTimetable(
                TimetableCompanion(
                  name: drift.Value(
                    (int.parse(timetables.last.name) + 1).toString(),
                  ),
                ),
              );
            }
          },
          tooltip: "create".tr(),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
