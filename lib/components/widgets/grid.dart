import 'package:flutter/material.dart';
import 'package:timetable/components/widgets/tile.dart';

/// Grid for the grid view of the Timetable screen.
class Grid extends StatelessWidget {
  const Grid({
    super.key,
    required this.tileHeight,
    required this.tileWidth,
    required this.rows,
    required this.columns,
    required this.grid,
  });

  final double tileWidth;
  final double tileHeight;
  final int rows;
  final int columns;
  final List<List<Tile?>> grid;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: grid
          .map((c) => Column(
                children: c
                    .whereType<Tile>()
                    .map(
                      (e) => SizedBox(
                        height: e.height * tileHeight,
                        width: e.width * tileWidth,
                        child: e.child,
                      ),
                    )
                    .toList(),
              ))
          .toList(),
    );
  }
}
