import 'package:hooks_riverpod/hooks_riverpod.dart';

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
  SettingsNotifier() : super(Settings());

  void updateCompactMode(bool compactMode) {
    final newState = state.copy(
      compactMode: compactMode,
    );
    state = newState;
  }

  void updateHideLocation(bool hideLocation) {
    final newState = state.copy(
      hideLocation: hideLocation,
    );
    state = newState;
  }

  void updateSingleLetterDays(bool singleLetterDays) {
    final newState = state.copy(
      singleLetterDays: singleLetterDays,
    );
    state = newState;
  }
}

final settingsProvider = StateNotifierProvider<SettingsNotifier, Settings>(
  (ref) => SettingsNotifier(),
);
