import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timetable/screens/select_time.dart';
import 'package:timetable/screens/settings.dart';
import 'package:timetable/utilities/add_cell_modal.dart';
import 'package:timetable/utilities/grid_utils.dart';

int rows = 11 + 1; // extra for days row
int columns = 7 + 1; // extra for times column

const List<String> days = [
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
  'Sunday'
];

class GridPage extends StatefulWidget {
  const GridPage({Key? key}) : super(key: key);

  @override
  GridPageState createState() => GridPageState();
}

class GridPageState extends State<GridPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Timetable'),
      ),
      body: const GridScreen(),
    );
  }
}

class GridScreen extends StatefulWidget {
  const GridScreen({super.key});

  @override
  GridScreenState createState() => GridScreenState();
}

class GridScreenState extends State<GridScreen> {
  Set<int> selectedCellIndices = {};
  late SharedPreferences prefs;
  Map<int, String> cellLabels = {};
  Map<int, String> cellLocations = {};
  Map<int, Color> cellColors = {};
  late TimeSettings timeSettings;

  final _addCellModalKey = GlobalKey<AddCellModalState>();

  @override
  void initState() {
    super.initState();
    loadSelectedCells();
  }

  int calculateRowCount(TimeOfDay startTime, TimeOfDay endTime) {
    int startHour = startTime.hour;
    int endHour = endTime.hour;

    int slotCount = (endHour - startHour).abs();

    if (slotCount == 0) {
      slotCount = 24;
    }

    return slotCount + 1;
  }

  Future<void> loadSelectedCells() async {
    prefs = await SharedPreferences.getInstance();

    List<int>? savedIndices =
        prefs.getStringList('selectedIndices')?.map(int.parse).toList();
    if (savedIndices != null) {
      setState(() {
        selectedCellIndices = savedIndices.toSet();
        for (int index in selectedCellIndices) {
          String? label = prefs.getString('cellLabel_$index');
          String? subLabel = prefs.getString('cellSubLabel_$index');
          int? colorValue = prefs.getInt('cellColor_$index');

          if (label != null) {
            cellLabels[index] = label;
          }
          if (subLabel != null) {
            cellLocations[index] = subLabel;
          }
          if (colorValue != null) {
            cellColors[index] = Color(colorValue);
          }
        }
      });
    }
  }

  Future<void> saveSelectedCells() async {
    List<String> selectedIndicesAsString =
        selectedCellIndices.map((index) => index.toString()).toList();
    await prefs.setStringList('selectedIndices', selectedIndicesAsString);

    for (int index in selectedCellIndices) {
      String? label = cellLabels[index];
      String? subLabel = cellLocations[index];
      Color? color = cellColors[index];

      if (label != null) {
        await prefs.setString('cellLabel_$index', label);
      }
      if (subLabel != null) {
        await prefs.setString('cellSubLabel_$index', subLabel);
      }
      if (color != null) {
        await prefs.setInt('cellColor_$index', color.value);
      }
    }
  }

  void _addNewCell(
    int rowIndex,
    int columnIndex,
    String newCellLabel,
    Color newCellColor,
    String newCellLocation,
  ) {
    int cellIndex = (rowIndex + 1) * columns + columnIndex;

    setState(() {
      if (selectedCellIndices.contains(cellIndex)) {
        cellLabels[cellIndex] = newCellLabel;
        cellLocations[cellIndex] = newCellLocation;

        if (newCellColor != Colors.blue) {
          cellColors[cellIndex] = newCellColor;
        }
      } else {
        selectedCellIndices.add(cellIndex);
        cellLabels[cellIndex] = newCellLabel;
        cellLocations[cellIndex] = newCellLocation;

        if (newCellColor != Colors.blue) {
          cellColors[cellIndex] = newCellColor;
        }
      }
    });

    saveSelectedCells();
  }

  void _showModalBottomSheet(int rowIndex, int columnIndex) async {
    String formattedTime = getFormattedTime(rowIndex, context);
    int cellIndex = (rowIndex + 1) * columns + columnIndex;

    String? existingCellLabel = cellLabels[cellIndex];
    String? existingCellSubLabel = cellLocations[cellIndex];

    double currentChildSize = 0.415;

    String? newCellLabel = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      builder: (BuildContext context) {
        return DraggableScrollableActuator(
          child: DraggableScrollableSheet(
            initialChildSize: 0.415,
            minChildSize: 0.415,
            maxChildSize: 1,
            snap: true,
            expand: false,
            builder: (context, scrollController) {
              return Column(
                children: [
                  AddCellModal(
                    key: _addCellModalKey,
                    time: formattedTime,
                    day: days[columnIndex - 1],
                    existingCellLabel: existingCellLabel,
                    existingCellSubLabel: existingCellSubLabel,
                    onCellSaved: (label, location, color) {
                      _addNewCell(
                        rowIndex,
                        columnIndex,
                        label,
                        color,
                        location,
                      );
                    },
                    existingCellColor: cellColors[cellIndex],
                    scrollController: scrollController,
                  ),
                ],
              );
            },
          ),
        );
      },
    );

    if (existingCellLabel != null && isDelete) {
      if (newCellLabel != existingCellLabel) {
        _showDeleteConfirmation(cellIndex);
      }
    }
  }

  void _showDeleteConfirmation(int cellIndex) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          content: const Text('Delete this Subject?'),
          contentPadding: const EdgeInsets.all(20),
          actions: [
            TextButton(
              onPressed: () {
                isDelete = false;
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  selectedCellIndices.remove(cellIndex);
                  cellLabels.remove(cellIndex);
                  cellLocations.remove(cellIndex);
                  cellColors.remove(cellIndex);
                });
                isDelete = false;
                Navigator.pop(dialogContext);
                saveSelectedCells();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildIndividualCellWidget(int cellIndex) {
    String? label = cellLabels[cellIndex];
    String? subLabel = cellLocations[cellIndex];
    Color? color = cellColors[cellIndex];

    return GestureDetector(
      onTap: () {
        _showModalBottomSheet(cellIndex ~/ columns - 1, cellIndex % columns);
      },
      child: Align(
        alignment: Alignment.center,
        child: Container(
          width: 97.0,
          height: 97.0,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            color: color,
            borderRadius: BorderRadius.circular(5.0),
          ),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(5, 5, 5, 0),
              child: Text(
                label.toString(),
                style: TextStyle(
                    color: color!.computeLuminance() > .7
                        ? Colors.black
                        : Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
              child: Text(
                subLabel.toString(),
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: color.computeLuminance() > .7
                        ? Colors.black.withOpacity(0.6)
                        : Colors.white.withOpacity(0.75),
                    fontWeight: FontWeight.bold),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final settingsData = Provider.of<SettingsData>(context, listen: false);
    final timeSettings = Provider.of<TimeSettings>(context, listen: false);

    int rowCount = calculateRowCount(
        timeSettings.defaultStartTime, timeSettings.defaultEndTime);

    List<String> times = getTimesList(context);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: columns * 100 + 16,
        child: Stack(
          children: [
            GridView.count(
              crossAxisCount: columns,
              crossAxisSpacing: 0.0,
              mainAxisSpacing: 0.0,
              children: List.generate((rowCount) * columns + 1, (index) {
                int rowIndex = (index - columns) ~/ columns;
                int columnIndex = (index - columns) % columns;

                BorderSide leftBorder = columnIndex == 1
                    ? BorderSide.none
                    : const BorderSide(color: Colors.grey);
                BorderSide bottomBorder = rowIndex == rowCount - 2
                    ? BorderSide.none
                    : const BorderSide(color: Colors.grey);

                if (index == 0) {
                  return Container();
                } else if (index < columns) {
                  // days row
                  return Container(
                    width: 100.0,
                    height: 50.0,
                    alignment: Alignment.bottomCenter,
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      settingsData.isSingleLetterDays
                          ? days[index - 1][0]
                          : days[index - 1],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  );
                } else if (columnIndex == 0) {
                  // times column
                  return Transform.translate(
                    offset: Offset(
                        -10.0,
                        MediaQuery.of(context).alwaysUse24HourFormat
                            ? -7.5
                            : -16.0),
                    child: Container(
                      alignment: Alignment.topRight,
                      child: Text(
                        getFormattedTime(rowIndex, context,
                            startHour: timeSettings.defaultStartTime.hour),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                } else {
                  // main grid
                  return GestureDetector(
                    onTap: () {
                      _showModalBottomSheet(rowIndex, columnIndex);
                    },
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: columnIndex == 0
                                ? null
                                : rowIndex == rowCount
                                    ? null
                                    : Border(
                                        left: leftBorder,
                                        bottom: bottomBorder,
                                      ),
                          ),
                          alignment: Alignment.centerRight,
                          child: columnIndex == 0
                              ? Align(
                                  alignment: Alignment.centerRight,
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        0.0, 0.0, 0.0, 0.0),
                                    child: Text(
                                      times[rowIndex],
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                )
                              : Align(
                                  alignment: columnIndex == columns - 1
                                      ? Alignment.centerLeft
                                      : Alignment.centerRight,
                                  child: Container(
                                    width: columnIndex == 1
                                        ? 90
                                        : columnIndex == columns - 1
                                            ? 80
                                            : 100,
                                    height: 1,
                                    color:
                                        const Color(0xFFB4B8AB).withOpacity(.5),
                                  ),
                                ),
                        ),
                        if (selectedCellIndices.contains(index))
                          _buildIndividualCellWidget(index)
                      ],
                    ),
                  );
                }
              }),
            ),
          ],
        ),
      ),
    );
  }
}
