import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:timetable/models/settings.dart';
import 'package:timetable/screens/settings_screen.dart';
import 'package:timetable/screens/timetable_screen.dart';

/// The navigation bar.
class Navigation extends ConsumerStatefulWidget {
  const Navigation({super.key});

  @override
  ConsumerState<Navigation> createState() => _NavigationState();
}

class _NavigationState extends ConsumerState<Navigation> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final navbarToggle = ref.watch(settingsProvider).navbarVisible;

    return Scaffold(
      bottomNavigationBar: Visibility(
        visible: navbarToggle,
        child: NavigationBar(
          onDestinationSelected: _onTabTapped,
          selectedIndex: currentPageIndex,
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
        child: _buildPage(currentPageIndex),
      ),
    );
  }

  void _onTabTapped(int index) {
    if (currentPageIndex != index) {
      setState(() {
        currentPageIndex = index;
      });
    }
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