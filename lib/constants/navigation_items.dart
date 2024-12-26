import 'package:flutter/material.dart';

/// A list of navigation items used in the app's bottom navigation bar.
const List<({IconData selectedIcon, IconData icon, String labelKey})>
    navigationItems = [
  (
    selectedIcon: Icons.table_chart,
    icon: Icons.table_chart_outlined,
    labelKey: 'timetable',
  ),
  (
    selectedIcon: Icons.settings,
    icon: Icons.settings_outlined,
    labelKey: 'settings',
  ),
];
