import 'package:flutter/material.dart';

/// List of the preset colors.
enum ColorsList {
  lightYellow('Light Yellow', Color(0xFFFFEB3B)),
  yellow('Yellow', Color(0xFFFFb700)),
  orange('Orange', Color(0xFFFF5722)),

  pink('Pink', Color(0xFFEA698B)),
  purpureus('Purpureus', Color(0xFFA23EB4)),
  purple('Purple', Color(0xFF673AB7)),

  lighBlue('Light Blue', Color(0xFF2196F3)),
  blue('Blue', Color(0xFF0077B6)),
  darkBlue('Dark Blue', Color(0xFF03045E)),

  lightGreen('Light Green', Color(0xFF95D5B2)),
  green('Green', Color(0xFF4CAF50)),
  darkGreen('Dark Green', Color(0xFF1B4332)),

  lightRed('Light Red', Color(0xFFFF686B)),
  red('Red', Color(0xFFE01E37)),
  darkRed('Dark Red', Color(0xFF641220)),

  white('White', Color(0xFFFFFFFF)),
  grey('Grey', Color(0xFF9E9E9E)),
  black('Black', Color(0xFF000000));

  const ColorsList(this.label, this.color);
  final String label;
  final Color color;
}

/// hand picked colors for the app theme color.
enum AppColorsList {
  yellow('yellow', Colors.yellow),
  orange('orange', Colors.orange),

  pink('pink', Colors.pink),
  deepPurple('deep_purple', Colors.deepPurple),

  indigo('indigo', Colors.indigo),
  blue('blue', Colors.blue),

  lightGreen('light_green', Colors.lightGreen),
  green('green', Colors.green),
  teal('teal', Colors.teal),

  red('red', Colors.red),
  // i have no idea what the color name is in french
  // so i just renamed it to light red because it's similar tbh
  lightRed('light_red', Colors.redAccent);

  const AppColorsList(this.label, this.color);
  final String label;
  final Color color;
}
