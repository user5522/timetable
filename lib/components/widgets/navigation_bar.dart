import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:timetable/provider/settings.dart';
import 'package:timetable/screens/settings_screen.dart';
import 'package:timetable/screens/timetable_screen.dart';

/// The navigation bar.
class Navigation extends HookConsumerWidget {
  const Navigation({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navbarToggle = ref.watch(settingsProvider).navbarVisible;
    final currentPageIndex = useState(0);

    void onTabTapped(int index) {
      if (currentPageIndex.value != index) {
        currentPageIndex.value = index;
      }
    }

    return Scaffold(
      bottomNavigationBar: Visibility(
        visible: navbarToggle,
        child: NavigationBar(
          onDestinationSelected: onTabTapped,
          selectedIndex: currentPageIndex.value,
          destinations: const <Widget>[
            NavigationDestination(
              selectedIcon: Icon(Icons.table_chart),
              icon: Icon(Icons.table_chart_outlined),
              label: 'Timetable',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.settings),
              icon: Icon(Icons.settings_outlined),
              label: 'Settings',
            ),
          ],
        ),
      ),
      body: PageTransitionSwitcher(
        duration: const Duration(milliseconds: 500),
        transitionBuilder: (child, animation, secondaryAnimation) {
          return SharedAxisTransition(
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              transitionType: SharedAxisTransitionType.horizontal,
              child: child);
        },
        child: _buildPage(currentPageIndex.value),
      ),
    );
  }

  Widget _buildPage(int pageIndex) {
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
