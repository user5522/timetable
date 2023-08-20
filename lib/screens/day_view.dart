import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timetable/screens/grid.dart';
import 'package:timetable/screens/select_time.dart';
import 'package:timetable/utilities/grid_utils.dart';

class DayView extends StatelessWidget {
  final Map<int, String> cellLabels;
  final Map<int, String> cellLocations;
  final Map<int, Color> cellColors;

  DayView({
    super.key,
    required this.cellLabels,
    required this.cellLocations,
    required this.cellColors,
  });

  late PageController controller;

  @override
  Widget build(BuildContext context) {
    controller = PageController(initialPage: DateTime.now().weekday - 1);

    return PageView.builder(
      itemCount: 7,
      pageSnapping: true,
      controller: controller,
      itemBuilder: (context, index) {
        int startDay = ((DateTime.monday + index - 1) % 7 + 1);

        List<int> startDayCellIndices = cellLabels.keys
            .where((cellIndex) => (cellIndex % columns) == startDay)
            .toList();

        startDayCellIndices.sort();

        return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  days[startDay - 1],
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: startDayCellIndices.map((cellIndex) {
                    return _buildCell(context, cellIndex);
                  }).toList(),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  static const timeSlotDuration = Duration(hours: 1);

  TimeOfDay calculateStartTime(BuildContext context, int rowIndex) {
    final timeSettings = Provider.of<TimeSettings>(context, listen: false);

    return timeSettings.defaultStartTime.replacing(
      hour: (timeSettings.defaultStartTime.hour +
          (rowIndex * timeSlotDuration.inHours)) %
          24,
    );
  }

  Widget _buildCell(BuildContext context, int cellIndex) {
    String? label = cellLabels[cellIndex];
    String? subLabel = cellLocations[cellIndex];
    Color? color = cellColors[cellIndex];

    int rowIndex = (cellIndex - columns) ~/ columns;
    TimeOfDay startTime = calculateStartTime(context, rowIndex);
    TimeOfDay endTime = startTime.replacing(
      hour: (startTime.hour + 1) % 24,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 2.5,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 17,
          horizontal: 17,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 1),
          borderRadius: BorderRadius.circular(10),
          color: color,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label.toString(),
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: color!.computeLuminance() > .7
                      ? Colors.black
                      : Colors.white,
                  fontSize: 17),
            ),
            Row(
              children: [
                Text(
                  startTime.format(context),
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: color.computeLuminance() > .7
                        ? Colors.black.withOpacity(0.6)
                        : Colors.white.withOpacity(0.75),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: Icon(
                    Icons.arrow_forward,
                    color: color.computeLuminance() > .7
                        ? Colors.black.withOpacity(0.6)
                        : Colors.white.withOpacity(0.75),
                    size: 15,
                  ),
                ),
                Text(
                  endTime.format(context),
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: color.computeLuminance() > .7
                        ? Colors.black.withOpacity(0.6)
                        : Colors.white.withOpacity(0.75),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                if (subLabel != "")
                Icon(
                  Icons.location_on,
                  color: color.computeLuminance() > .7
                      ? Colors.black.withOpacity(0.6)
                      : Colors.white.withOpacity(0.75),
                  size: 15,
                ),
                  Text(
                    subLabel.toString(),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: color.computeLuminance() > .7
                            ? Colors.black.withOpacity(0.6)
                            : Colors.white.withOpacity(0.75)),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
