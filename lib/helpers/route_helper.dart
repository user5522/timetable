import 'package:flutter/material.dart';

/// "Custom" route transitions and navigation
class RouteHelper<T> extends MaterialPageRoute<T> {
  RouteHelper({
    required super.builder,
    super.settings,
  }) : super(
          maintainState: false,
          fullscreenDialog: false,
        );
}
