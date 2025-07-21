import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:timetable/core/constants/timetable_views.dart';
import 'package:timetable/core/utils/views.dart';
import 'package:timetable/features/settings/providers/settings.dart';

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
    /// The dropdown menu entries of each TbViews value.
    List<DropdownMenuEntry<TbViews>> viewsEntries() {
      final viewEntries = <DropdownMenuEntry<TbViews>>[];

      for (final TbViews option in TbViews.values) {
        final label = getViewLabel(option);

        viewEntries.add(
          DropdownMenuEntry<TbViews>(value: option, label: label),
        );
      }
      return viewEntries.toList();
    }

    return Row(
      children: [
        const Text('default_tb_view').tr(),
        const Spacer(),
        DropdownMenu<TbViews>(
          // this is needed to change the initial selection with the new locale
          key: ValueKey(context.locale),
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
