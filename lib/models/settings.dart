import 'package:hooks_riverpod/hooks_riverpod.dart';

class Settings {
  final bool compactMode;
  final bool showLocation;

  Settings({
    this.compactMode = false,
    this.showLocation = false,
  });

  Settings copy({
    bool? compactMode,
    bool? showLocation,
  }) =>
      Settings(
        compactMode: compactMode ?? this.compactMode,
        showLocation: showLocation ?? this.showLocation,
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

  void updateShowLocation(bool showLocation) {
    final newState = state.copy(
      showLocation: showLocation,
    );
    state = newState;
  }
}

final settingsProvider = StateNotifierProvider<SettingsNotifier, Settings>(
  (ref) => SettingsNotifier(),
);
