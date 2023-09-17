import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings {
  final bool customTimePeriod;
  final bool compactMode;
  final bool hideLocation;
  final bool singleLetterDays;
  final bool rotationWeeks;
  final TimeOfDay customStartTime;
  final TimeOfDay customEndTime;
  final bool hideSunday;

  Settings({
    this.customTimePeriod = false,
    this.compactMode = false,
    this.hideLocation = false,
    this.singleLetterDays = false,
    this.rotationWeeks = false,
    this.customStartTime = const TimeOfDay(hour: 08, minute: 00),
    this.customEndTime = const TimeOfDay(hour: 18, minute: 00),
    this.hideSunday = false,
  });

  Settings copy({
    bool? customTimePeriod,
    bool? compactMode,
    bool? hideLocation,
    bool? singleLetterDays,
    bool? rotationWeeks,
    TimeOfDay? customStartTime,
    TimeOfDay? customEndTime,
    bool? hideSunday,
  }) =>
      Settings(
        customTimePeriod: customTimePeriod ?? this.customTimePeriod,
        compactMode: compactMode ?? this.compactMode,
        hideLocation: hideLocation ?? this.hideLocation,
        singleLetterDays: singleLetterDays ?? this.singleLetterDays,
        rotationWeeks: rotationWeeks ?? this.rotationWeeks,
        customStartTime: customStartTime ?? this.customStartTime,
        customEndTime: customEndTime ?? this.customEndTime,
        hideSunday: hideSunday ?? this.hideSunday,
      );
}

class SettingsNotifier extends StateNotifier<Settings> {
  SettingsNotifier() : super(Settings()) {
    loadSettings();
  }

  void updateCustomTimePeriod(bool customTimePeriod) {
    final newState = state.copy(
      customTimePeriod: customTimePeriod,
    );
    state = newState;
    _saveCustomTimePeriod(customTimePeriod);
  }

  void updateHideSunday(bool hideSunday) {
    final newState = state.copy(
      hideSunday: hideSunday,
    );
    state = newState;
    _saveHideSunday(hideSunday);
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

  void updateRotationWeeks(bool rotationWeeks) {
    final newState = state.copy(
      rotationWeeks: rotationWeeks,
    );
    state = newState;
    _saveRotationWeeks(rotationWeeks);
  }

  void updateCustomStartTime(TimeOfDay customStartTime) {
    final newState = state.copy(
      customStartTime: customStartTime,
    );
    state = newState;
    _saveCustomStartTime(customStartTime);
  }

  void updateCustomEndTime(TimeOfDay customEndTime) {
    final newState = state.copy(
      customEndTime: customEndTime,
    );
    state = newState;
    _saveCustomEndTime(customEndTime);
  }

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await _loadCompactMode(prefs);
    await _loadHideSunday(prefs);
    await _loadSingleLetterDays(prefs);
    await _loadHideLocation(prefs);
    await _loadRotationWeeks(prefs);
    await _loadCustomTimePeriod(prefs);
    await _loadCustomStartTime(prefs);
    await _loadCustomEndTime(prefs);
  }

  Future<void> _loadCustomTimePeriod(SharedPreferences prefs) async {
    final customTimePeriod = prefs.getBool('customTimePeriod');
    if (customTimePeriod != null) {
      state = state.copy(customTimePeriod: customTimePeriod);
    }
  }

  Future<void> _saveCustomTimePeriod(bool customTimePeriodValue) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(
      'customTimePeriod',
      customTimePeriodValue,
    );
  }

  Future<void> _loadHideSunday(SharedPreferences prefs) async {
    final hideSunday = prefs.getBool('hideSunday');
    if (hideSunday != null) {
      state = state.copy(hideSunday: hideSunday);
    }
  }

  Future<void> _saveHideSunday(bool hideSundayValue) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(
      'hideSunday',
      hideSundayValue,
    );
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

  Future<void> _loadRotationWeeks(SharedPreferences prefs) async {
    final rotationWeeks = prefs.getBool('rotationWeeks');
    if (rotationWeeks != null) {
      state = state.copy(rotationWeeks: rotationWeeks);
    }
  }

  Future<void> _saveRotationWeeks(bool rotationWeeksValue) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(
      'rotationWeeks',
      rotationWeeksValue,
    );
  }

  Future<void> _loadCustomStartTime(SharedPreferences prefs) async {
    final customStartHour = prefs.getInt('customStartHour');
    final customStartMinute = prefs.getInt('customStartMinute');
    if (customStartHour != null && customStartMinute != null) {
      state = state.copy(
        customStartTime: TimeOfDay(
          hour: customStartHour,
          minute: customStartMinute,
        ),
      );
    }
  }

  Future<void> _saveCustomStartTime(TimeOfDay customStartTimeValue) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(
      'customStartHour',
      customStartTimeValue.hour,
    );
    await prefs.setInt(
      'customStartMinute',
      customStartTimeValue.minute,
    );
  }

  Future<void> _loadCustomEndTime(SharedPreferences prefs) async {
    final customEndHour = prefs.getInt('customEndHour');
    final customEndMinute = prefs.getInt('customEndMinute');
    if (customEndHour != null && customEndMinute != null) {
      state = state.copy(
        customEndTime: TimeOfDay(
          hour: customEndHour,
          minute: customEndMinute,
        ),
      );
    }
  }

  Future<void> _saveCustomEndTime(TimeOfDay customEndTimeValue) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(
      'customEndHour',
      customEndTimeValue.hour,
    );
    await prefs.setInt(
      'customEndMinute',
      customEndTimeValue.minute,
    );
  }
}

final settingsProvider = StateNotifierProvider<SettingsNotifier, Settings>(
  (ref) => SettingsNotifier(),
);
