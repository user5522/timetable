import 'package:animations/animations.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:timetable/provider/settings.dart';
import 'package:timetable/provider/subjects.dart';
import 'package:timetable/screens/settings_screen.dart';
import 'package:timetable/screens/timetable_screen.dart';

/// The app's bottom navigation bar.
class Navigation extends HookConsumerWidget {
  const Navigation({
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
          destinations: <Widget>[
            NavigationDestination(
              selectedIcon: const Icon(Icons.table_chart),
              icon: const Icon(Icons.table_chart_outlined),
              label: "timetable".plural(1),
            ),
            NavigationDestination(
              selectedIcon: const Icon(Icons.settings),
              icon: const Icon(Icons.settings_outlined),
              label: 'settings'.plural(1),
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
        child: _buildPage(currentPageIndex.value, subject),
      ),
    );
  }

  Widget _buildPage(int pageIndex, SubjectNotifier subject) {
    switch (pageIndex) {
      case 0:
        return TimetableScreen(
          key: Key(subject.getSubjects().toString()),
        );
      case 1:
        return const SettingsScreen();
      default:
        return TimetableScreen(
          key: Key(subject.getSubjects().toString()),
        );
    }
  }
}
