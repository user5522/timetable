import 'package:flutter/material.dart';

class ActChip extends StatelessWidget {
  final Widget label;
  final VoidCallback? onPressed;
  final bool enabled;

  const ActChip({
    super.key,
    required this.label,
    this.onPressed,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      side: enabled ? BorderSide.none : null,
      backgroundColor:
          enabled ? Theme.of(context).colorScheme.outlineVariant : null,
      onPressed: onPressed,
      label: label,
    );
  }
}
