import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timetable/constants/languages.dart';

/// Language state management
class LanguageNotifier extends StateNotifier<Locale> {
  LanguageNotifier() : super(languages[0]) {
    loadLanguage();
  }

  /// change current language ([Locale])
  void changeLanguage(Locale newLanguage) {
    state = newLanguage;
    saveLanguage(newLanguage);
  }

  /// returns current language ([Locale])
  Locale getLanguage() {
    return state;
  }

  /// loads current language (from an index) from shared preferences
  Future<void> loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLanguageIndex = prefs.getInt('language');
    if (savedLanguageIndex == null) return;

    state = languages[savedLanguageIndex];
  }

  /// saves current language (index) to shared preferences
  Future<void> saveLanguage(Locale language) async {
    final prefs = await SharedPreferences.getInstance();
    final int index = languages.indexOf(language);
    await prefs.setInt(
      'language',
      index,
    );
  }
}

final languageProvider = StateNotifierProvider<LanguageNotifier, Locale>(
  (ref) => LanguageNotifier(),
);
