import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// Custom color picker screen for the color configuration screen.
class ColorPickerScreen extends HookWidget {
  /// this is the color that will be changed by the color picker.
  final ValueNotifier<Color> color;

  const ColorPickerScreen({
    super.key,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    /// controller for the hex input in the color picker.
    final TextEditingController hexInputController = TextEditingController();

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          ColorPicker(
            pickerColor: color.value,
            hexInputBar: true,
            onColorChanged: (Color newColor) => color.value = newColor,
            pickerAreaBorderRadius: BorderRadius.circular(10),
            hexInputController: hexInputController,
          ),
        ],
      ),
    );
  }
}
