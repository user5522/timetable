import 'package:flutter/material.dart';

class ActChip extends StatelessWidget {
  final Widget label;
  final VoidCallback? onPressed;

  const ActChip({
    super.key,
    required this.label,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      side: BorderSide.none,
      backgroundColor: Theme.of(context).colorScheme.outlineVariant,
      onPressed: onPressed,
      label: label,
    );
  }
}
