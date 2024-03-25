import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:timetable/constants/timetable_views.dart';
import 'package:timetable/provider/settings.dart';

/// default timetable view options dropdown menu.
class DefaultViewOptions extends StatelessWidget {
  final SettingsNotifier settings;
  final TbViews defaultTimetableView;

  const DefaultViewOptions({
    super.key,
    required this.settings,
    required this.defaultTimetableView,
  });

  @override
  Widget build(BuildContext context) {
    String getViewLabel(TbViews view) {
      switch (view) {
        case TbViews.grid:
          return 'grid'.tr();
        case TbViews.day:
          return 'day'.plural(1);
      }
    }

    List<DropdownMenuEntry<TbViews>> viewsEntries() {
      final viewEntries = <DropdownMenuEntry<TbViews>>[];

      for (final TbViews option in TbViews.values) {
        final label = getViewLabel(option);

        viewEntries.add(
          DropdownMenuEntry<TbViews>(
            value: option,
            label: label,
          ),
        );
      }
      return viewEntries.toList();
    }

    return Row(
      children: [
        const Text('default_tb_view').tr(),
        const Spacer(),
        DropdownMenu<TbViews>(
          width: 130,
          dropdownMenuEntries: viewsEntries(),
          label: const Text("view").tr(),
          initialSelection: defaultTimetableView,
          onSelected: (value) {
            settings.updateDefaultTbView(value!);
          },
        ),
      ],
    );
  }
}
