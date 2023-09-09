import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:timetable/constants/theme_options.dart';
import 'package:timetable/screens/timetable_screen.dart';
import 'package:timetable/provider/themes.dart';
import 'package:timetable/screens/settings_screen.dart';

void main() {
  runApp(const ProviderScope(
    child: Timetable(),
  ));
}

class Timetable extends ConsumerWidget {
  const Timetable({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var themeMode = ref.watch(themeModeProvider);
    final Brightness systemBrightness =
        MediaQuery.of(context).platformBrightness;

    return MaterialApp(
      color: Colors.white,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: themeMode == ThemeModeOption.auto
              ? systemBrightness
              : themeMode == ThemeModeOption.dark
                  ? Brightness.dark
                  : Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const NavigationExample(),
    );
  }
}

class NavigationExample extends StatefulWidget {
  const NavigationExample({super.key});

  @override
  State<NavigationExample> createState() => _NavigationExampleState();
}

class _NavigationExampleState extends State<NavigationExample> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
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
        return const TimetablePage();
      case 1:
        return const SettingsPage();
      default:
        return const TimetablePage();
    }
  }
}
