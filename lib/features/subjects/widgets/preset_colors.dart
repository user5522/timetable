import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:timetable/core/constants/colors.dart';

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
    final screenWidth = MediaQuery.of(context).size.width;

    BorderRadius? getBorderRadius(
      int index,
      int colorsPerRow,
      int rowCount,
      int totalColors,
    ) {
      const radius = Radius.circular(10);

      final isTopLeft = index == 0;
      final isTopRight = index == (colorsPerRow - 1);
      final isBottomLeft = index ==
          (totalColors -
              ((totalColors % colorsPerRow == 0)
                  ? colorsPerRow
                  : totalColors % colorsPerRow));
      final isBottomRight = index == (totalColors - 1);

      if (isTopLeft) return const BorderRadius.only(topLeft: radius);
      if (isTopRight) return const BorderRadius.only(topRight: radius);
      if (isBottomLeft) return const BorderRadius.only(bottomLeft: radius);
      if (isBottomRight) return const BorderRadius.only(bottomRight: radius);

      return null;
    }

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        scrollDirection: Axis.vertical,
        children: [
          Wrap(
            children: colors.asMap().entries.map((entry) {
              final index = entry.key;
              final colorItem = entry.value;

              return buildColorTile(
                color: colorItem.color,
                width: (screenWidth - 32.0) / 3.0,
                isSelected: colorItem.color == color.value,
                borderRadius: getBorderRadius(
                  index,
                  colorsPerRow,
                  rowCount,
                  colors.length,
                ),
                onTap: () {
                  selectedColorIndex.value = index;
                  color.value = colorItem.color;
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget buildColorTile({
    required Color color,
    required double width,
    required bool isSelected,
    required VoidCallback onTap,
    required BorderRadius? borderRadius,
  }) {
    final iconColor =
        color.computeLuminance() > 0.7 ? Colors.black : Colors.white;
    final checkIcon = Icon(Icons.check, color: iconColor, size: 30);

    return Material(
      color: color,
      borderRadius: borderRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: borderRadius,
        child: SizedBox(
          height: 56,
          width: width,
          child: isSelected ? checkIcon : null,
        ),
      ),
    );
  }
}
