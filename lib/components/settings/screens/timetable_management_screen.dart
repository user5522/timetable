import 'package:flutter/material.dart';
import 'package:drift/drift.dart' as drift;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:timetable/components/widgets/alert_dialog.dart';
import 'package:timetable/components/widgets/list_tile_group.dart';
import 'package:timetable/db/database.dart';
import 'package:timetable/provider/settings.dart';
import 'package:timetable/provider/timetables.dart';

/// Manage The number of Timetables in the app.
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
        title: const Text("Timetable Management"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SwitchListTile(
              title: const Text("Multiple Timetables"),
              value: multipleTimetables,
              onChanged: (bool value) {
                settings.updateMultipleTimetables(value);
              },
            ),
            ListTile(
              title: const Text("Reset"),
              onTap: () {
                showDialog<void>(
                  context: context,
                  barrierDismissible: true,
                  builder: (BuildContext context) {
                    return ShowAlertDialog(
                      content: const Text(
                        "Reseting will delete all subjects other than the default one's.",
                      ),
                      approveButtonText: "Reset",
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
              title: const Text("Manage"),
              enabled: multipleTimetables ? true : false,
              textColor: Theme.of(context).colorScheme.primary,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 75),
              child: ListTileGroup(
                children: List.generate(
                  timetables.length,
                  (i) => ListItem(
                    title: Row(
                      children: [
                        Text("Timetable ${timetables[i].name}"),
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
                                    content: const Text(
                                      "Deleting a timetable will delete it's corresponding subjects.",
                                    ),
                                    approveButtonText: "Delete",
                                    onApprove: () {
                                      timetable.deleteTimetable(timetables[i]);
                                      Navigator.of(context).pop();
                                    },
                                  );
                                },
                              );
                            },
                            icon: const Icon(Icons.delete_outline),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: multipleTimetables
          ? FloatingActionButton(
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
              child: const Icon(Icons.add),
            )
          : Container(),
    );
  }
}
