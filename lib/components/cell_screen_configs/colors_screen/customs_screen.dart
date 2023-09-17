import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class CustomsScreen extends HookWidget {
  const CustomsScreen({
    Key? key,
    required this.color,
  }) : super(key: key);

  final ValueNotifier<Color> color;

  static final TextEditingController hexInputController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    void changeColor(Color color) {
      this.color.value = color;
      print(color);
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: color.value,
            hexInputBar: true,
            onColorChanged: changeColor,
            pickerAreaBorderRadius: BorderRadius.circular(10),
            hexInputController: hexInputController,
          ),
        ),
      ),
    );
  }
}
