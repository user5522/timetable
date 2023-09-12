import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings {
  final bool compactMode;
  final bool hideLocation;
  final bool singleLetterDays;

  Settings({
    this.compactMode = false,
    this.hideLocation = false,
    this.singleLetterDays = false,
  });

  Settings copy({
    bool? compactMode,
    bool? hideLocation,
    bool? singleLetterDays,
  }) =>
      Settings(
        compactMode: compactMode ?? this.compactMode,
        hideLocation: hideLocation ?? this.hideLocation,
        singleLetterDays: singleLetterDays ?? this.singleLetterDays,
      );
}

class SettingsNotifier extends StateNotifier<Settings> {
  SettingsNotifier() : super(Settings()) {
    loadSettings();
  }

  void updateCompactMode(bool compactMode) {
    final newState = state.copy(
      compactMode: compactMode,
    );
    state = newState;
    _saveCompactMode(compactMode);
  }

  void updateHideLocation(bool hideLocation) {
    final newState = state.copy(
      hideLocation: hideLocation,
    );
    state = newState;
    _saveHideLocation(hideLocation);
  }

  void updateSingleLetterDays(bool singleLetterDays) {
    final newState = state.copy(
      singleLetterDays: singleLetterDays,
    );
    state = newState;
    _saveSingleLetterDays(singleLetterDays);
  }

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await _loadCompactMode(prefs);
    await _loadSingleLetterDays(prefs);
    await _loadHideLocation(prefs);
  }

  Future<void> _loadCompactMode(SharedPreferences prefs) async {
    final compactMode = prefs.getBool('compactMode');
    if (compactMode != null) {
      state = state.copy(compactMode: compactMode);
    }
  }

  Future<void> _saveCompactMode(bool compactModeValue) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(
      'compactMode',
      compactModeValue,
    );
  }

  Future<void> _loadHideLocation(SharedPreferences prefs) async {
    final hideLocation = prefs.getBool('hideLocation');
    if (hideLocation != null) {
      state = state.copy(hideLocation: hideLocation);
    }
  }

  Future<void> _saveHideLocation(bool hideLocationValue) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(
      'hideLocation',
      hideLocationValue,
    );
  }

  Future<void> _loadSingleLetterDays(SharedPreferences prefs) async {
    final singleLetterDays = prefs.getBool('singleLetterDays');
    if (singleLetterDays != null) {
      state = state.copy(singleLetterDays: singleLetterDays);
    }
  }

  Future<void> _saveSingleLetterDays(bool singleLetterDaysValue) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(
      'singleLetterDays',
      singleLetterDaysValue,
    );
  }
}

final settingsProvider = StateNotifierProvider<SettingsNotifier, Settings>(
  (ref) => SettingsNotifier(),
);
