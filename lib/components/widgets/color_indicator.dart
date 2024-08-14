import 'package:flutter/material.dart';

class ColorIndicator extends StatelessWidget {
  final Color color;
  final bool? monetTheming;

  const ColorIndicator({
    super.key,
    required this.color,
    this.monetTheming = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 17,
      width: 17,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: color.withAlpha(!monetTheming! ? 255 : 128),
        border: Border.all(
          color: Colors.black,
        ),
      ),
    );
  }
}
