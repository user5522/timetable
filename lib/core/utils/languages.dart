import 'package:flutter/material.dart';

/// for each value of the enum it will give a corresponding label.
String getLanguageLabel(Locale language) {
  const en = Locale('en', 'US');
  const fr = Locale('fr', 'FR');

  switch (language) {
    case en:
      return 'English';
    case fr:
      return 'Français';
    default:
      return 'English';
  }
}
