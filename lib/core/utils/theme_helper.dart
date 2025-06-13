import 'package:flutter/material.dart';
import 'package:timetable/core/constants/theme_options.dart';

/// Theme and color scheme management
class ThemeHelper {
  static ColorScheme getColorScheme({
    required bool monetTheming,
    required ThemeOption theme,
    required Brightness systemBrightness,
    required ColorScheme? lightDynamic,
    required ColorScheme? darkDynamic,
    required Color appThemeColor,
  }) {
    if (!(lightDynamic == null || darkDynamic == null) && monetTheming) {
      return getMonetColorScheme(
        theme,
        systemBrightness,
        lightDynamic,
        darkDynamic,
      );
    }

    return getSeedColorScheme(theme, systemBrightness, appThemeColor);
  }

  /// generates a color scheme based on the given parameters.
  ///
  /// It determines the color scheme to use based on the theme option, system brightness, and dynamic color schemes.
  /// If monet theming is enabled and dynamic color schemes are provided, it uses the dynamic color schemes based on the system brightness.
  /// Otherwise, it generates a color scheme from a seed color based on the theme option and system brightness.
  static ColorScheme getMonetColorScheme(
    ThemeOption theme,
    Brightness systemBrightness,
    ColorScheme lightDynamic,
    ColorScheme darkDynamic,
  ) {
    if (theme == ThemeOption.auto) {
      return systemBrightness == Brightness.light ? lightDynamic : darkDynamic;
    }
    return theme == ThemeOption.light ? lightDynamic : darkDynamic;
  }

  static ColorScheme getSeedColorScheme(
    ThemeOption theme,
    Brightness systemBrightness,
    Color seedColor,
  ) {
    final brightness = theme == ThemeOption.auto
        ? systemBrightness
        : theme == ThemeOption.dark
            ? Brightness.dark
            : Brightness.light;

    return ColorScheme.fromSeed(seedColor: seedColor, brightness: brightness);
  }
}
