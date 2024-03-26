import 'package:flutter/material.dart';

class ColorIndicator extends StatelessWidget {
  final Color color;
  const ColorIndicator({
    super.key,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 17,
      width: 17,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: color,
        border: Border.all(
          color: Colors.black,
        ),
      ),
    );
  }
}
