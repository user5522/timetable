import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timetable/db/models/settings.dart';

/// Settings' [StateNotifier].
class SettingsNotifier extends StateNotifier<Settings> {
  SettingsNotifier() : super(Settings()) {
    loadSettings();
  }

  void updateMonetThemeing(bool monetTheming) {
    final newState = state.copy(
      monetTheming: monetTheming,
    );
    state = newState;
    _saveBool(monetTheming, 'monetTheming');
  }

  void updateNavbarVisible(bool navbarVisible) {
    final newState = state.copy(
      navbarVisible: navbarVisible,
    );
    state = newState;
    _saveBool(navbarVisible, 'navbarVisible');
  }

  void updateHideTransparentSubject(bool hideTransparentSubject) {
    final newState = state.copy(
      hideTransparentSubject: hideTransparentSubject,
    );
    state = newState;
    _saveBool(hideTransparentSubject, 'hideTransparentSubject');
  }

  void updateCustomTimePeriod(bool customTimePeriod) {
    final newState = state.copy(
      customTimePeriod: customTimePeriod,
    );
    state = newState;
    _saveBool(customTimePeriod, 'customTimePeriod');
  }

  void updateAutoCompleteColor(bool autoCompleteColor) {
    final newState = state.copy(
      autoCompleteColor: autoCompleteColor,
    );
    state = newState;
    _saveBool(autoCompleteColor, 'autoCompleteColor');
  }

  void updateHideSunday(bool hideSunday) {
    final newState = state.copy(
      hideSunday: hideSunday,
    );
    state = newState;
    _saveBool(hideSunday, 'hideSunday');
  }

  void updateCompactMode(bool compactMode) {
    final newState = state.copy(
      compactMode: compactMode,
    );
    state = newState;
    _saveBool(compactMode, 'compactMode');
  }

  void updateHideLocation(bool hideLocation) {
    final newState = state.copy(
      hideLocation: hideLocation,
    );
    state = newState;
    _saveBool(hideLocation, 'hideLocation');
  }

  void updateSingleLetterDays(bool singleLetterDays) {
    final newState = state.copy(
      singleLetterDays: singleLetterDays,
    );
    state = newState;
    _saveBool(singleLetterDays, 'singleLetterDays');
  }

  void updateRotationWeeks(bool rotationWeeks) {
    final newState = state.copy(
      rotationWeeks: rotationWeeks,
    );
    state = newState;
    _saveBool(rotationWeeks, 'rotationWeeks');
  }

  void updateCustomStartTime(TimeOfDay customStartTime) {
    final newState = state.copy(
      customStartTime: customStartTime,
    );
    state = newState;
    _saveTimeOfDay(customStartTime, 'customStartHour', 'customStartMinute');
  }

  void updateCustomEndTime(TimeOfDay customEndTime) {
    final newState = state.copy(
      customEndTime: customEndTime,
    );
    state = newState;
    _saveTimeOfDay(customEndTime, 'customEndHour', 'customEndMinute');
  }

// TODO: find a better system for saving settings to SharedPreferences.

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await _loadCompactMode(prefs);
    await _loadAutoCompleteColor(prefs);
    await _loadHideSunday(prefs);
    await _loadSingleLetterDays(prefs);
    await _loadHideLocation(prefs);
    await _loadRotationWeeks(prefs);
    await _loadCustomTimePeriod(prefs);
    await _loadCustomStartTime(prefs);
    await _loadCustomEndTime(prefs);
    await _loadHideTransparentSubject(prefs);
    await _loadNavbarVisible(prefs);
    await _loadMonetTheming(prefs);
  }

  Future<void> _saveBool(bool boolValue, String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(
      key,
      boolValue,
    );
  }

  Future<void> _saveTimeOfDay(
      TimeOfDay timeOfDayValue, String hourKey, String minuteKey) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(
      hourKey,
      timeOfDayValue.hour,
    );
    await prefs.setInt(
      minuteKey,
      timeOfDayValue.minute,
    );
  }

  Future<void> _loadMonetTheming(SharedPreferences prefs) async {
    final monetTheming = prefs.getBool('monetTheming');
    if (monetTheming != null) {
      state = state.copy(monetTheming: monetTheming);
    }
  }

  Future<void> _loadNavbarVisible(SharedPreferences prefs) async {
    final navbarVisible = prefs.getBool('navbarVisible');
    if (navbarVisible != null) {
      state = state.copy(navbarVisible: navbarVisible);
    }
  }

  Future<void> _loadHideTransparentSubject(SharedPreferences prefs) async {
    final hideTransparentSubject = prefs.getBool('hideTransparentSubject');
    if (hideTransparentSubject != null) {
      state = state.copy(hideTransparentSubject: hideTransparentSubject);
    }
  }

  Future<void> _loadAutoCompleteColor(SharedPreferences prefs) async {
    final autoCompleteColor = prefs.getBool('autoCompleteColor');
    if (autoCompleteColor != null) {
      state = state.copy(autoCompleteColor: autoCompleteColor);
    }
  }

  Future<void> _loadCustomTimePeriod(SharedPreferences prefs) async {
    final customTimePeriod = prefs.getBool('customTimePeriod');
    if (customTimePeriod != null) {
      state = state.copy(customTimePeriod: customTimePeriod);
    }
  }

  Future<void> _loadHideSunday(SharedPreferences prefs) async {
    final hideSunday = prefs.getBool('hideSunday');
    if (hideSunday != null) {
      state = state.copy(hideSunday: hideSunday);
    }
  }

  Future<void> _loadCompactMode(SharedPreferences prefs) async {
    final compactMode = prefs.getBool('compactMode');
    if (compactMode != null) {
      state = state.copy(compactMode: compactMode);
    }
  }

  Future<void> _loadHideLocation(SharedPreferences prefs) async {
    final hideLocation = prefs.getBool('hideLocation');
    if (hideLocation != null) {
      state = state.copy(hideLocation: hideLocation);
    }
  }

  Future<void> _loadSingleLetterDays(SharedPreferences prefs) async {
    final singleLetterDays = prefs.getBool('singleLetterDays');
    if (singleLetterDays != null) {
      state = state.copy(singleLetterDays: singleLetterDays);
    }
  }

  Future<void> _loadRotationWeeks(SharedPreferences prefs) async {
    final rotationWeeks = prefs.getBool('rotationWeeks');
    if (rotationWeeks != null) {
      state = state.copy(rotationWeeks: rotationWeeks);
    }
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
}

final settingsProvider = StateNotifierProvider<SettingsNotifier, Settings>(
  (ref) => SettingsNotifier(),
);
