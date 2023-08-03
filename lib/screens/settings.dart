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

  bool get isSingleLetterDays => _isSingleLetterDays;

  set isSingleLetterDays(bool value) {
    _isSingleLetterDays = value;
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
    _loadThemeMode();

    final timeSettings = Provider.of<TimeSettings>(context, listen: false);
    defaultStartTime = timeSettings.defaultStartTime;
    defaultEndTime = timeSettings.defaultEndTime;
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

  Future<void> _loadThemeMode() async {
    ThemeModeOption themeMode = await _getThemeMode();
    setState(() {
      _selectedThemeMode = themeMode;
    });
  }

  Future<void> _saveThemeMode(ThemeModeOption themeMode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('theme_mode', themeMode.index);

    setState(() {
      _selectedThemeMode = themeMode;
    });
  }

  Future<ThemeModeOption> _getThemeMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? themeModeIndex = prefs.getInt('theme_mode');
    return ThemeModeOption.values[themeModeIndex ?? 0];
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

  Future<void> _saveCustomTimePreference(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('customTimeEnabled', value);

    final timeSettings = Provider.of<TimeSettings>(context, listen: false);
    if (!value) {
      timeSettings.defaultStartTime = defaultStartTime;
      timeSettings.defaultEndTime = defaultEndTime;
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

  void _handleSingleLetterDaysToggle(bool value) async {
    setState(() {
      _isSingleLetterDays = value;
    });
    _saveSingleLetterDaysPreference(value);
    Provider.of<SettingsData>(context, listen: false).isSingleLetterDays =
        value;
  }

  Future<void> _saveSingleLetterDaysPreference(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('singleLetterDays', value);
  }

  @override
  Widget build(BuildContext context) {
    final themeChanger = Provider.of<ThemeChanger>(context);

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
                    value: _selectedThemeMode,
                    onChanged: (newValue) {
                      setState(() {
                        _selectedThemeMode = newValue!;
                      });
                      _saveThemeMode(newValue!);
                      themeChanger.setThemeMode(newValue);
                    },
                    items: ThemeModeOption.values.map((themeMode) {
                      return DropdownMenuItem<ThemeModeOption>(
                        value: themeMode,
                        child: Text(getThemeModeLabel(themeMode)),
                      );
                    }).toList(),
                  ),
                ],
              ),
              onTap: () {},
            ),
            SwitchListTile(
              title: const Text('Single Letter Days'),
              value: _isSingleLetterDays,
              onChanged: _handleSingleLetterDaysToggle,
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

class DropdownMenu<T> extends StatelessWidget {
  final T value;
  final void Function(T?)? onChanged;
  final List<DropdownMenuItem<T>> items;

  const DropdownMenu({
    Key? key,
    required this.value,
    required this.onChanged,
    required this.items,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: DropdownButtonHideUnderline(
        child: Align(
          alignment: Alignment.center,
          child: DropdownButton<T>(
            value: value,
            onChanged: onChanged,
            items: items,
          ),
        ),
      ),
    );
  }
}
