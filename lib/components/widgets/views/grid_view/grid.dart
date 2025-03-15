import 'package:flutter/material.dart';
import 'package:timetable/components/widgets/views/grid_view/tile.dart';

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
      children: List.generate(
        grid.length,
        (i) {
          final c = grid[i];
          final fc = c.whereType<Tile>().toList();
          return Column(
            children: List.generate(
              fc.length,
              (i) {
                final e = fc[i];
                return SizedBox(
                  height: e.height * tileHeight,
                  width: e.width * tileWidth,
                  child: e.child,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
