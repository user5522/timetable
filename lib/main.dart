import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timetable/screens/grid.dart';
import 'package:timetable/screens/select_time.dart';
import 'package:timetable/screens/settings.dart';
import 'package:animations/animations.dart';
import 'package:timetable/utilities/cell_modal.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeChanger()),
        ChangeNotifierProvider(create: (context) => SettingsData()),
        ChangeNotifierProvider(create: (context) => TimeSettings()),
        ChangeNotifierProvider(create: (context) => GridData()),
        ChangeNotifierProvider(create: (context) => CellModalData()),
      ],
      child: const Timetable(),
    ),
  );
}

class Timetable extends StatelessWidget {
  const Timetable({super.key});

  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
      future: loadSettingsData(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final themeChanger = Provider.of<ThemeChanger>(context);

          final Brightness systemBrightness =
              MediaQuery.of(context).platformBrightness;

          return MaterialApp(
            title: 'Timetable',
            color: Colors.white,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.deepPurple,
                brightness: themeChanger.themeMode == ThemeModeOption.auto
                    ? systemBrightness
                    : themeChanger.themeMode == ThemeModeOption.dark
                        ? Brightness.dark
                        : Brightness.light,
              ),
              useMaterial3: true,
            ),
            home: const NavigationExample(),
          );
        } else {
          return const MaterialApp(
            home: Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }
      },
    );
  }

  Future<void> loadSettingsData(BuildContext context) async {
    final themeChanger = Provider.of<ThemeChanger>(context, listen: false);
    final settingsData = Provider.of<SettingsData>(context, listen: false);

    final timeSettings = Provider.of<TimeSettings>(context, listen: false);

    ThemeModeOption themeMode = await _getThemeMode();
    settingsData.isSingleLetterDays = await _getSingleLetterDays();
    settingsData.defaultToDayView = await _getDefaultToDV();
    settingsData.showDVNavbar = await _getShowDVNavbar();
    themeChanger.setThemeMode(themeMode);

    bool isCustomTimeEnabled = await _getCustomTimeEnabled();
    TimeOfDay defaultStartTime = timeSettings.defaultStartTime;
    TimeOfDay defaultEndTime = timeSettings.defaultEndTime;

    await loadSelectedTimes(
        timeSettings, isCustomTimeEnabled, defaultStartTime, defaultEndTime);
  }

  Future<void> loadSelectedTimes(
      TimeSettings timeSettings,
      bool isCustomTimeEnabled,
      TimeOfDay defaultStartTime,
      TimeOfDay defaultEndTime) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? startHour = prefs.getInt('selectedStartTimeHour');
    int? startMinute = prefs.getInt('selectedStartTimeMinute');
    int? endHour = prefs.getInt('selectedEndTimeHour');
    int? endMinute = prefs.getInt('selectedEndTimeMinute');

    if (isCustomTimeEnabled) {
      if (startHour != null && startMinute != null) {
        timeSettings.defaultStartTime =
            TimeOfDay(hour: startHour, minute: startMinute);
      }
      if (endHour != null && endMinute != null) {
        timeSettings.defaultEndTime =
            TimeOfDay(hour: endHour, minute: endMinute);
      }
    } else {
      timeSettings.defaultStartTime = defaultStartTime;
      timeSettings.defaultEndTime = defaultEndTime;
    }
  }

  Future<bool> _getCustomTimeEnabled() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isCustomTimeEnabled = prefs.getBool('customTimeEnabled');
    return isCustomTimeEnabled ?? false;
  }

  Future<bool> _getSingleLetterDays() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isSingleLetterDays = prefs.getBool('singleLetterDays');
    return isSingleLetterDays ?? false;
  }

  Future<bool> _getShowDVNavbar() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? showDVNavbar = prefs.getBool('dvNavbar');
    return showDVNavbar ?? false;
  }

  Future<bool> _getDefaultToDV() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? defaultToDayView = prefs.getBool('defaultToDV');
    return defaultToDayView ?? false;
  }

  Future<ThemeModeOption> _getThemeMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? themeModeIndex = prefs.getInt('theme_mode');
    return ThemeModeOption.values[themeModeIndex ?? 0];
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
        return const GridPage();
      case 1:
        return const SettingsPage();
      default:
        return const GridPage();
    }
  }
}
