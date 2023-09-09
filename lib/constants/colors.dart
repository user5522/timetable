import 'package:flutter/material.dart';

enum ColorsList {
  lightYellow('Light Yellow', Color(0xFFFFEB3B)),
  yellow('Yellow', Color(0xffffb700)),
  orange('Orange', Color(0xFFFF5722)),

  pink('Pink', Color(0xffea698b)),
  purpureus('Purpureus', Color(0xff973aa8)),
  purple('Purple', Color(0xFF673AB7)),

  lighBlue('Light Blue', Color(0xFF2196f3)),
  blue('Blue', Color(0xff0077b6)),
  darkBlue('Dark Blue', Color(0xff03045e)),

  lightGreen('Light Green', Color(0xff95d5b2)),
  green('Green', Color(0xFF4CAF50)),
  darkGreen('Dark Green', Color(0xff1b4332)),

  lightRed('Light Red', Color(0xffff686b)),
  red('Red', Color(0xffe01e37)),
  darkRed('Dark Red', Color(0xff641220)),

  white('White', Color(0xFFFFFFFF)),
  grey('Grey', Color(0xFF9E9E9E)),
  black('Black', Color(0xFF000000));

  const ColorsList(this.label, this.color);
  final String label;
  final Color color;
}
