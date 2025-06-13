import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:drift/drift.dart' as drift;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:timetable/shared/widgets/alert_dialog.dart';
import 'package:timetable/shared/widgets/list_item_group.dart';
import 'package:timetable/core/db/database.dart';
import 'package:timetable/features/settings/providers/settings.dart';
import 'package:timetable/features/timetable/providers/timetables.dart';

class TimetableManagementScreen extends ConsumerWidget {
  const TimetableManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsNotifier = ref.read(settingsProvider.notifier);
    final timetableNotifier = ref.read(timetableProvider.notifier);
    final multipleTimetables = ref.watch(settingsProvider).multipleTimetables;
    final timetables = ref.watch(timetableProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("manage_timetables").tr()),
      body: ListView(
        children: [
          buildMultipleTimetablesSwitch(
            multipleTimetables: multipleTimetables,
            settingsNotifier: settingsNotifier,
          ),
          buildResetButton(
            context: context,
            timetableNotifier: timetableNotifier,
          ),
          buildManageSection(
            context: context,
            multipleTimetables: multipleTimetables,
          ),
          buildTimetablesList(
            timetables: timetables,
            multipleTimetables: multipleTimetables,
            timetableNotifier: timetableNotifier,
            context: context,
          ),
        ],
      ),
      floatingActionButton: buildFAB(
        timetables: timetables,
        multipleTimetables: multipleTimetables,
        timetableNotifier: timetableNotifier,
      ),
    );
  }

  Widget buildMultipleTimetablesSwitch({
    required bool multipleTimetables,
    required SettingsNotifier settingsNotifier,
  }) {
    return SwitchListTile(
      secondary: const Icon(Icons.backup_table_outlined, size: 20),
      visualDensity: const VisualDensity(horizontal: -4),
      title: const Text("multiple_timetables").tr(),
      value: multipleTimetables,
      onChanged: settingsNotifier.updateMultipleTimetables,
    );
  }

  Widget buildResetButton({
    required BuildContext context,
    required TimetableNotifier timetableNotifier,
  }) {
    return ListTile(
      leading: const Icon(Icons.delete_forever_outlined, size: 20),
      horizontalTitleGap: 8,
      title: const Text("reset").tr(),
      onTap: () => showResetDialog(context, timetableNotifier),
    );
  }

  Widget buildManageSection({
    required BuildContext context,
    required bool multipleTimetables,
  }) {
    return ListTile(
      dense: true,
      title: const Text("manage").tr(),
      enabled: multipleTimetables,
      textColor: Theme.of(context).colorScheme.primary,
    );
  }

  Widget buildTimetablesList({
    required List timetables,
    required bool multipleTimetables,
    required TimetableNotifier timetableNotifier,
    required BuildContext context,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 75),
      child: ListItemGroup(
        children: List.generate(
          timetables.length,
          (i) => buildTimetableItem(
            timetableItem: timetables[i],
            firstTimetable: timetables[0],
            multipleTimetables: multipleTimetables,
            timetableNotifier: timetableNotifier,
            context: context,
          ),
        ),
      ),
    );
  }

  ListItem buildTimetableItem({
    required Timetable timetableItem,
    required Timetable firstTimetable,
    required bool multipleTimetables,
    required TimetableNotifier timetableNotifier,
    required BuildContext context,
  }) {
    final isFirstTimetable = timetableItem == firstTimetable;
    final opacity = isFirstTimetable ? 1.0 : (multipleTimetables ? 1.0 : 0.5);
    final showDeleteButton = !isFirstTimetable && multipleTimetables;

    return ListItem(
      title: Opacity(
        opacity: opacity,
        child: Row(
          children: [
            Text("${"timetable".plural(1)} ${timetableItem.name}"),
            const Spacer(),
            if (showDeleteButton)
              buildDeleteButton(context, timetableNotifier, timetableItem),
          ],
        ),
      ),
      onTap: () {},
    );
  }

  Widget buildDeleteButton(
    BuildContext context,
    TimetableNotifier timetable,
    Timetable timetableItem,
  ) {
    return IconButton(
      onPressed: () => showDeleteDialog(context, timetable, timetableItem),
      icon: const Icon(Icons.delete_outline),
      tooltip: "delete".tr(),
    );
  }

  Widget? buildFAB({
    required List timetables,
    required bool multipleTimetables,
    required TimetableNotifier timetableNotifier,
  }) {
    final canAddTimetable = timetables.length < 5 && multipleTimetables;
    if (!canAddTimetable) return null;

    return FloatingActionButton(
      onPressed: () => addTimetable(timetables, timetableNotifier),
      tooltip: "create".tr(),
      child: const Icon(Icons.add),
    );
  }

  void showResetDialog(
    BuildContext context,
    TimetableNotifier timetableNotifier,
  ) {
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (_) => ShowAlertDialog(
        content: const Text("reset_timetables_dialog").tr(),
        approveButtonText: "reset".tr(),
        onApprove: () {
          timetableNotifier.resetData();
          Navigator.of(context).pop();
        },
      ),
    );
  }

  void showDeleteDialog(
    BuildContext context,
    TimetableNotifier timetableNotifier,
    Timetable timetableItem,
  ) {
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (_) => ShowAlertDialog(
        content: const Text("delete_timetable_dialog").tr(),
        approveButtonText: "delete".tr(),
        onApprove: () {
          timetableNotifier.deleteTimetable(timetableItem);
          Navigator.of(context).pop();
        },
      ),
    );
  }

  void addTimetable(List timetables, TimetableNotifier timetable) {
    final nextName = (int.parse(timetables.last.name) + 1).toString();
    timetable.addTimetable(TimetablesCompanion(name: drift.Value(nextName)));
  }
}
