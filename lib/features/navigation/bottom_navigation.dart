import 'package:animations/animations.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:timetable/core/constants/navigation_items.dart';
import 'package:timetable/features/settings/providers/settings.dart';
import 'package:timetable/features/subjects/providers/subjects.dart';
import 'package:timetable/features/settings/screens/settings.dart';
import 'package:timetable/features/timetable/screens/timetable.dart';

/// The app's bottom navigation bar.
class BottomNavigation extends HookConsumerWidget {
  const BottomNavigation({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navbarToggle = ref.watch(settingsProvider).navbarVisible;
    final subject = ref.watch(subjectProvider.notifier);
    final currentPageIndex = useState(0);

    void onTabTapped(int index) {
      if (currentPageIndex.value == index) return;
      currentPageIndex.value = index;
      return;
    }

    return Scaffold(
      bottomNavigationBar: Visibility(
        visible: navbarToggle,
        child: NavigationBar(
          onDestinationSelected: onTabTapped,
          selectedIndex: currentPageIndex.value,
          destinations: navigationItems
              .map((item) => NavigationDestination(
                    selectedIcon: Icon(item.selectedIcon),
                    icon: Icon(item.icon),
                    label: item.labelKey.plural(1),
                  ))
              .toList(),
        ),
      ),
      body: PageTransitionSwitcher(
        duration: const Duration(milliseconds: 500),
        transitionBuilder: (child, animation, secondaryAnimation) {
          return SharedAxisTransition(
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            transitionType: SharedAxisTransitionType.horizontal,
            child: child,
          );
        },
        child: _buildPage(currentPageIndex.value, subject),
      ),
    );
  }

  Widget _buildPage(int pageIndex, SubjectNotifier subject) {
    switch (pageIndex) {
      case 0:
        return const TimetableScreen();
      case 1:
        return const SettingsScreen();
      default:
        return const TimetableScreen();
    }
  }
}
