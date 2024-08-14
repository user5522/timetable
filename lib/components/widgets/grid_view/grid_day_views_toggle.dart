import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// Toggle between day and grid/week views.
class GridDayViewsToggle extends HookWidget {
  final ValueNotifier<bool> isGridView;
  const GridDayViewsToggle({
    super.key,
    required this.isGridView,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: isGridView.value ? 'day_view'.tr() : 'grid_view'.tr(),
      onPressed: () {
        isGridView.value = !isGridView.value;
      },
      selectedIcon: const Icon(Icons.view_agenda_outlined),
      icon: const Icon(Icons.grid_view_outlined),
      isSelected: isGridView.value,
    );
  }
}
