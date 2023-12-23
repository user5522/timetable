import 'package:flutter/material.dart';

/// Settings data model.
class Settings {
  final bool customTimePeriod;
  final bool compactMode;
  final bool hideLocation;
  final bool singleLetterDays;
  final bool rotationWeeks;
  final TimeOfDay customStartTime;
  final TimeOfDay customEndTime;
  final bool hideSunday;
  final bool autoCompleteColor;
  final bool hideTransparentSubject;
  final bool navbarVisible;
  final bool monetTheming;

  // settings defaults
  Settings({
    this.customTimePeriod = false,
    this.compactMode = true,
    this.hideLocation = false,
    this.singleLetterDays = false,
    this.rotationWeeks = false,
    this.customStartTime = const TimeOfDay(hour: 08, minute: 00),
    this.customEndTime = const TimeOfDay(hour: 18, minute: 00),
    this.hideSunday = false,
    this.autoCompleteColor = true,
    this.hideTransparentSubject = true,
    this.navbarVisible = true,
    this.monetTheming = false,
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
    bool? autoCompleteColor,
    bool? hideTransparentSubject,
    bool? navbarVisible,
    bool? monetTheming,
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
        autoCompleteColor: autoCompleteColor ?? this.autoCompleteColor,
        hideTransparentSubject:
            hideTransparentSubject ?? this.hideTransparentSubject,
        navbarVisible: navbarVisible ?? this.navbarVisible,
        monetTheming: monetTheming ?? this.monetTheming,
      );
}
