import 'package:flutter/material.dart';

class Tile extends StatelessWidget {
  const Tile({
    super.key,
    this.height = 1,
    this.width = 1,
    required this.child,
  });

  final int height;
  final double width;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return child;
  }
}
