import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'select_time.dart';

class ThemeChanger with ChangeNotifier {
  ThemeModeOption themeMode = ThemeModeOption.auto;

  void setThemeMode(ThemeModeOption newThemeMode) {
    themeMode = newThemeMode;
    notifyListeners();
  }
}

class SettingsData with ChangeNotifier {
  bool _isSingleLetterDays = false;
  bool _showDVNavbar = false;

  bool get isSingleLetterDays => _isSingleLetterDays;
  bool get showDVNavbar => _showDVNavbar;

  set isSingleLetterDays(bool value) {
    _isSingleLetterDays = value;
    notifyListeners();
  }

  set showDVNavbar(bool value) {
    _showDVNavbar = value;
    notifyListeners();
  }
}

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  bool _isCustomTimeEnabled = false;
  bool _isSingleLetterDays = false;
  bool _showDVNavbar = false;
  ThemeModeOption _selectedThemeMode = ThemeModeOption.auto;

  TimeOfDay defaultStartTime = const TimeOfDay(hour: 8, minute: 0);
  TimeOfDay defaultEndTime = const TimeOfDay(hour: 18, minute: 0);

  @override
  void initState() {
    super.initState();
    loadSettings();
  }

  void loadSettings() async {
    await _loadCustomTimePreference();
    await _loadSingleLetterDaysPreference();
    await _loadDVNavbarPreference();
    _loadThemeMode();

    final timeSettings = Provider.of<TimeSettings>(context, listen: false);
    defaultStartTime = timeSettings.defaultStartTime;
    defaultEndTime = timeSettings.defaultEndTime;
  }

  Future<void> _resetSelectedTimes() async {
    final timeSettings = Provider.of<TimeSettings>(context, listen: false);

    timeSettings.defaultStartTime = const TimeOfDay(hour: 8, minute: 0);
    timeSettings.defaultEndTime = const TimeOfDay(hour: 18, minute: 0);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('selectedStartTimeHour', 8);
    await prefs.setInt('selectedStartTimeMinute', 0);
    await prefs.setInt('selectedEndTimeHour', 18);
    await prefs.setInt('selectedEndTimeMinute', 0);
  }

  void _handleCustomTimeToggle(bool value) async {
    setState(() {
      _isCustomTimeEnabled = value;
    });
    await _saveCustomTimePreference(value);

    if (!value) {
      await _resetSelectedTimes();
    }
  }

  void _handleSingleLetterDaysToggle(bool value) async {
    setState(() {
      _isSingleLetterDays = value;
    });
    _saveSingleLetterDaysPreference(value);
    Provider.of<SettingsData>(context, listen: false).isSingleLetterDays =
        value;
  }

  void _handleDVNavbarToggle(bool value) async {
    setState(() {
      _showDVNavbar = value;
    });
    _saveDVNavbarPreference(value);
    Provider.of<SettingsData>(context, listen: false).showDVNavbar =
        value;
  }

  Future<void> _saveThemeMode(ThemeModeOption themeMode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('theme_mode', themeMode.index);

    setState(() {
      _selectedThemeMode = themeMode;
    });
  }

  Future<void> _saveCustomTimePreference(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('customTimeEnabled', value);

    final timeSettings = Provider.of<TimeSettings>(context, listen: false);
    if (!value) {
      timeSettings.defaultStartTime = defaultStartTime;
      timeSettings.defaultEndTime = defaultEndTime;
    }
  }

  Future<void> _saveSingleLetterDaysPreference(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('singleLetterDays', value);
  }

  Future<void> _saveDVNavbarPreference(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('dvNavbar', value);
  }

  Future<ThemeModeOption> _loadThemeModePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? themeModeIndex = prefs.getInt('theme_mode');
    return ThemeModeOption.values[themeModeIndex ?? 0];
  }

  Future<void> _loadThemeMode() async {
    ThemeModeOption themeMode = await _loadThemeModePreference();
    setState(() {
      _selectedThemeMode = themeMode;
    });
  }

  Future<void> _loadCustomTimePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isCustomTimeEnabled = prefs.getBool('customTimeEnabled');
    if (isCustomTimeEnabled != null) {
      setState(() {
        _isCustomTimeEnabled = isCustomTimeEnabled;
      });
    }
  }

  Future<void> _loadSingleLetterDaysPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isSingleLetterDays = prefs.getBool('singleLetterDays');
    if (isSingleLetterDays != null) {
      setState(() {
        _isSingleLetterDays = isSingleLetterDays;
      });
    }
  }

  Future<void> _loadDVNavbarPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? showDVNavbar = prefs.getBool('dvNavbar');
    if (showDVNavbar != null) {
      setState(() {
        _showDVNavbar = showDVNavbar;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeChanger = Provider.of<ThemeChanger>(context);
    final List<DropdownMenuEntry<ThemeModeOption>> themeEntries =
        <DropdownMenuEntry<ThemeModeOption>>[];
    for (final ThemeModeOption color in ThemeModeOption.values) {
      themeEntries.add(
        DropdownMenuEntry<ThemeModeOption>(
            value: color, label: getThemeModeLabel(color)),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SwitchListTile(
              title: const Text('Custom Time Period'),
              subtitle: const Text(
                'Warning: may or may not break Subjects\' locations',
              ),
              value: _isCustomTimeEnabled,
              onChanged: _handleCustomTimeToggle,
            ),
            if (_isCustomTimeEnabled)
              ListTile(
                title: const Text('Customize Time Period'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          CustomTimeSelectionPage.withDefaults(
                        _isCustomTimeEnabled,
                        defaultStartTime,
                        defaultEndTime,
                      ),
                    ),
                  );
                },
              ),
            ListTile(
              title: Row(
                children: [
                  const Text('Theme Mode'),
                  const Spacer(),
                  DropdownMenu<ThemeModeOption>(
                    width: 120,
                    dropdownMenuEntries: themeEntries,
                    label: const Text("Theme"),
                    initialSelection: _selectedThemeMode,
                    onSelected: (value) {
                      setState(() {
                        _selectedThemeMode = value!;
                      });
                      _saveThemeMode(value!);
                      themeChanger.setThemeMode(value);
                    },
                  ),
                ],
              ),
              onTap: () {},
            ),
            SwitchListTile(
              title: const Text('Single Letter Days'),
              subtitle: const Text('Shows \'M\' instead of Monday, etc'),
              value: _isSingleLetterDays,
              onChanged: _handleSingleLetterDaysToggle,
            ),
            SwitchListTile(
              title: const Text('Days View NavBar'),
              subtitle: const Text(
                  'Toggles a navigation bar in the days view to navigate faster'),
              value: _showDVNavbar,
              onChanged: _handleDVNavbarToggle,
            ),
          ],
        ),
      ),
    );
  }

  String getThemeModeLabel(ThemeModeOption themeMode) {
    switch (themeMode) {
      case ThemeModeOption.dark:
        return 'Dark';
      case ThemeModeOption.auto:
        return 'System';
      case ThemeModeOption.light:
        return 'Light';
      default:
        return '';
    }
  }
}

enum ThemeModeOption { dark, auto, light }
