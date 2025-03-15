import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:timetable/constants/colors.dart';

/// Preset colors screen for the color configuration screen.
class PresetColorsScreen extends HookWidget {
  /// the color that will be changed by one of the presets
  final ValueNotifier<Color> color;
  final List<ColorsList> colors;
  final int colorsPerRow;

  const PresetColorsScreen({
    super.key,
    required this.color,
    required this.colors,
    this.colorsPerRow = 3,
  });

  @override
  Widget build(BuildContext context) {
    /// used for highlighting the selected color by default no color is selected
    // the default color is black, maybe i should have it as the default selected color
    final selectedColorIndex = useState(-1);
    const int colorsPerRow = 3;
    final int rowCount = (colors.length / colorsPerRow).ceil();

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        scrollDirection: Axis.vertical,
        children: [
          Column(
            children: List.generate(
              rowCount,
              (rowIndex) {
                return Row(
                  children: List.generate(
                    colorsPerRow,
                    (colIndex) {
                      final index = (rowIndex * colorsPerRow + colIndex);
                      final isCurrentColor = colors[index].color == color.value;

                      const topleft =
                          BorderRadius.only(topLeft: Radius.circular(10));
                      const topRight =
                          BorderRadius.only(topRight: Radius.circular(10));
                      const bottomRight =
                          BorderRadius.only(bottomRight: Radius.circular(10));
                      const bottomLeft =
                          BorderRadius.only(bottomLeft: Radius.circular(10));

                      final isTopLeft = index == 0;
                      final isTopRight = index == (colorsPerRow - 1);
                      final isBottomRight =
                          index == ((rowCount * colorsPerRow) - 1);
                      final isBottomLeft =
                          index == ((rowCount * colorsPerRow) - (colorsPerRow));

                      final borderRadius = isTopLeft
                          ? topleft
                          : isTopRight
                              ? topRight
                              : isBottomRight
                                  ? bottomRight
                                  : isBottomLeft
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
        ],
      ),
    );
  }
}
