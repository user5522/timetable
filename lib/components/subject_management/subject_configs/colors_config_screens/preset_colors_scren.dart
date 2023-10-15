import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:timetable/constants/colors.dart';

/// Preset colors screen for the color config screen.
class PresetColorsScreen extends HookWidget {
  final ValueNotifier<Color> color;

  const PresetColorsScreen({
    Key? key,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final selectedColorIndex = useState(-1);
    final List<ColorsList> colors = ColorsList.values.toList();
    const int colorsPerRow = 3;
    final int rowCount = (colors.length / colorsPerRow).ceil();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: List.generate(
              rowCount,
              (rowIndex) {
                return Row(
                  children: List.generate(
                    colorsPerRow,
                    (colIndex) {
                      final index = rowIndex * colorsPerRow + colIndex;
                      final isSelected = index == selectedColorIndex.value;

                      return InkWell(
                        onTap: () {
                          selectedColorIndex.value = index;
                          color.value = colors[index].color;
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              color: colors[index].color,
                              height: 50,
                              width:
                                  (MediaQuery.of(context).size.width - 32.0) /
                                      3.0,
                            ),
                            Visibility(
                              visible: isSelected,
                              child: Icon(
                                Icons.check,
                                color:
                                    colors[index].color.computeLuminance() > .7
                                        ? Colors.black
                                        : Colors.white,
                                size: 30,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
