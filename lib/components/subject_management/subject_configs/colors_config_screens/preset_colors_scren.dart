import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:timetable/constants/colors.dart';

/// Preset colors screen for the color configuration screen.
class PresetColorsScreen extends HookWidget {
  final ValueNotifier<Color> color;

  const PresetColorsScreen({
    super.key,
    required this.color,
  });

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
                      final index = (rowIndex * colorsPerRow + colIndex);
                      final isCurrentColor = colors[index].color == color.value;

                      const topleft = BorderRadius.only(
                        topLeft: Radius.circular(10),
                      );
                      const topRight = BorderRadius.only(
                        topRight: Radius.circular(10),
                      );
                      const bottomRight = BorderRadius.only(
                        bottomRight: Radius.circular(10),
                      );
                      const bottomLeft = BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                      );

                      final borderRadius = (index == 0)
                          ? topleft
                          : (index == (colorsPerRow - 1))
                              ? topRight
                              : (index == ((rowCount * colorsPerRow) - 1))
                                  ? bottomRight
                                  : (index ==
                                          ((rowCount * colorsPerRow) -
                                              (colorsPerRow)))
                                      ? bottomLeft
                                      : null;

                      return InkWell(
                        onTap: () {
                          selectedColorIndex.value = index;
                          color.value = colors[index].color;
                        },
                        borderRadius: borderRadius,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Ink(
                              decoration: BoxDecoration(
                                borderRadius: borderRadius,
                                color: colors[index].color,
                              ),
                              height: 50,
                              width:
                                  (MediaQuery.of(context).size.width - 32.0) /
                                      3.0,
                            ),
                            Visibility(
                              visible: isCurrentColor,
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
