import 'package:flutter/material.dart';

extension ColorExtension on Color {
  int toInt() {
    final al = (a * 255).round();
    final re = (r * 255).round();
    final gr = (g * 255).round();
    final bl = (b * 255).round();

    return (al << 24) | (re << 16) | (gr << 8) | bl;
  }
}
