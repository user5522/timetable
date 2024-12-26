import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:timetable/provider/settings.dart';

/// Toggles the navbar on and off to gain more screen space.
class NavbarToggle extends HookConsumerWidget {
  const NavbarToggle({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.read(settingsProvider.notifier);
    final navbarToggle = ref.watch(settingsProvider).navbarVisible;

    return IconButton(
      onPressed: () {
        settings.updateNavbarVisible(!navbarToggle);
      },
      tooltip: navbarToggle
          ? "fullscreen_tooltip_hide".tr()
          : "fullscreen_tooltip_show".tr(),
      selectedIcon: const Icon(
        Icons.fullscreen,
        size: 25,
      ),
      icon: const Icon(
        Icons.close_fullscreen_outlined,
        size: 20,
      ),
      isSelected: navbarToggle,
    );
  }
}
