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
  final bool multipleTimetables;
  final bool twentyFourHours;

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
    this.multipleTimetables = false,
    this.twentyFourHours = false,
  });

  Settings copyWith({
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
    bool? multipleTimetables,
    bool? twentyFourHours,
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
        multipleTimetables: multipleTimetables ?? this.multipleTimetables,
        twentyFourHours: twentyFourHours ?? this.twentyFourHours,
      );

  Map<String, dynamic> toJson() => {
        'customTimePeriod': customTimePeriod,
        'compactMode': compactMode,
        'hideLocation': hideLocation,
        'singleLetterDays': singleLetterDays,
        'rotationWeeks': rotationWeeks,
        'customStartTimeHour': customStartTime.hour,
        'customStartTimeMinute': customStartTime.minute,
        'customEndTimeHour': customEndTime.hour,
        'customEndTimeMinute': customEndTime.minute,
        'hideSunday': hideSunday,
        'autoCompleteColor': autoCompleteColor,
        'hideTransparentSubject': hideTransparentSubject,
        'navbarVisible': navbarVisible,
        'monetTheming': monetTheming,
        'multipleTimetables': multipleTimetables,
        'twentyFourHours': twentyFourHours,
      };

  factory Settings.fromJson(Map<String, dynamic> json) {
    final settings = Settings();

    return settings.copyWith(
      customTimePeriod: json['customTimePeriod'] as bool?,
      compactMode: json['compactMode'] as bool?,
      hideLocation: json['hideLocation'] as bool?,
      singleLetterDays: json['singleLetterDays'] as bool?,
      rotationWeeks: json['rotationWeeks'] as bool?,
      customStartTime: json['customStartTimeHour'] != null &&
              json['customStartTimeMinute'] != null
          ? TimeOfDay(
              hour: json['customStartTimeHour'] as int,
              minute: json['customStartTimeMinute'] as int,
            )
          : null,
      customEndTime: json['customEndTimeHour'] != null &&
              json['customEndTimeMinute'] != null
          ? TimeOfDay(
              hour: json['customEndTimeHour'] as int,
              minute: json['customEndTimeMinute'] as int,
            )
          : null,
      hideSunday: json['hideSunday'] as bool?,
      autoCompleteColor: json['autoCompleteColor'] as bool?,
      hideTransparentSubject: json['hideTransparentSubject'] as bool?,
      navbarVisible: json['navbarVisible'] as bool?,
      monetTheming: json['monetTheming'] as bool?,
      multipleTimetables: json['multipleTimetables'] as bool?,
      twentyFourHours: json['twentyFourHours'] as bool?,
    );
  }
}
