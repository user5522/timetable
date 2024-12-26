import 'package:flutter/material.dart';

class RouteHelper<T> extends MaterialPageRoute<T> {
  RouteHelper({
    required WidgetBuilder builder,
    RouteSettings? settings,
  }) : super(
          builder: builder,
          settings: settings,
          maintainState: false,
          fullscreenDialog: false,
        );
}
