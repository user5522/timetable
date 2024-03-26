import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timetable/constants/timetable_views.dart';
import 'package:timetable/db/models/settings.dart';

/// Settings' [StateNotifier].
class SettingsNotifier extends StateNotifier<Settings> {
  SettingsNotifier() : super(Settings()) {
    loadSettings();
  }

  void updateAppThemeColor(Color appThemeColor) {
    final newState = state.copyWith(
      appThemeColor: appThemeColor,
    );
    state = newState;
    saveSettings();
  }

  void updateDefaultTbView(TbViews tbView) {
    final newState = state.copyWith(
      defaultTimetableView: tbView,
    );
    state = newState;
    saveSettings();
  }

  void update24Hours(bool twentyFourHours) {
    final newState = state.copyWith(
      twentyFourHours: twentyFourHours,
    );
    state = newState;
    saveSettings();
  }

  void updateMultipleTimetables(bool multipleTimetables) {
    final newState = state.copyWith(
      multipleTimetables: multipleTimetables,
    );
    state = newState;
    saveSettings();
  }

  void updateMonetThemeing(bool monetTheming) {
    final newState = state.copyWith(
      monetTheming: monetTheming,
    );
    state = newState;
    saveSettings();
  }

  void updateNavbarVisible(bool navbarVisible) {
    final newState = state.copyWith(
      navbarVisible: navbarVisible,
    );
    state = newState;
    saveSettings();
  }

  void updateHideTransparentSubject(bool hideTransparentSubject) {
    final newState = state.copyWith(
      hideTransparentSubject: hideTransparentSubject,
    );
    state = newState;
    saveSettings();
  }

  void updateCustomTimePeriod(bool customTimePeriod) {
    final newState = state.copyWith(
      customTimePeriod: customTimePeriod,
    );
    state = newState;
    saveSettings();
  }

  void updateAutoCompleteColor(bool autoCompleteColor) {
    final newState = state.copyWith(
      autoCompleteColor: autoCompleteColor,
    );
    state = newState;
    saveSettings();
  }

  void updateHideSunday(bool hideSunday) {
    final newState = state.copyWith(
      hideSunday: hideSunday,
    );
    state = newState;
    saveSettings();
  }

  void updateCompactMode(bool compactMode) {
    final newState = state.copyWith(
      compactMode: compactMode,
    );
    state = newState;
    saveSettings();
  }

  void updateHideLocation(bool hideLocation) {
    final newState = state.copyWith(
      hideLocation: hideLocation,
    );
    state = newState;
    saveSettings();
  }

  void updateSingleLetterDays(bool singleLetterDays) {
    final newState = state.copyWith(
      singleLetterDays: singleLetterDays,
    );
    state = newState;
    saveSettings();
  }

  void updateRotationWeeks(bool rotationWeeks) {
    final newState = state.copyWith(
      rotationWeeks: rotationWeeks,
    );
    state = newState;
    saveSettings();
  }

  void updateCustomStartTime(TimeOfDay customStartTime) {
    final newState = state.copyWith(
      customStartTime: customStartTime,
    );
    state = newState;
    saveSettings();
  }

  void updateCustomEndTime(TimeOfDay customEndTime) {
    final newState = state.copyWith(
      customEndTime: customEndTime,
    );
    state = newState;
    saveSettings();
  }

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    final settingsJson = prefs.getString('settings');

    if (settingsJson == null) return;

    final settingsMap = jsonDecode(settingsJson);

    final loadedSettings = Settings.fromJson(settingsMap);
    state = loadedSettings;
  }

  Future<void> saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final settingsJson = state.toJson();

    await prefs.setString('settings', jsonEncode(settingsJson));
  }
}

final settingsProvider = StateNotifierProvider<SettingsNotifier, Settings>(
  (ref) => SettingsNotifier(),
);
