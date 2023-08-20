import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timetable/screens/day_view.dart';
import 'package:timetable/screens/select_time.dart';
import 'package:timetable/screens/settings.dart';
import 'package:timetable/utilities/add_cell_modal.dart';
import 'package:timetable/utilities/grid_utils.dart';

int rows = 11 + 1; // extra for days row
int columns = 7 + 1; // extra for times column

class GridPage extends StatefulWidget {
  const GridPage({Key? key}) : super(key: key);

  @override
  GridPageState createState() => GridPageState();
}

class GridPageState extends State<GridPage> {
  bool showCurrentDayCellsOnly = false;

  @override
  void initState() {
    super.initState();
    loadShowCurrentDayCellsOnly();
  }

  void loadShowCurrentDayCellsOnly() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      showCurrentDayCellsOnly =
          prefs.getBool('showCurrentDayCellsOnly') ?? true;
    });
  }

  void saveShowCurrentDayCellsOnly(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('showCurrentDayCellsOnly', value);
    setState(() {
      showCurrentDayCellsOnly = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Timetable'),
        actions: [
          IconButton(
            icon: const Icon(Icons.view_agenda_outlined),
            selectedIcon: const Icon(Icons.grid_view_outlined),
            isSelected: showCurrentDayCellsOnly,
            tooltip: "View",
            onPressed: () {
              saveShowCurrentDayCellsOnly(!showCurrentDayCellsOnly);
            },
          ),
        ],
      ),
      body: GridScreen(showCurrentDayCellsOnly: showCurrentDayCellsOnly),
    );
  }
}

class GridScreen extends StatefulWidget {
  final bool showCurrentDayCellsOnly;

  const GridScreen({
    super.key,
    required this.showCurrentDayCellsOnly,
  });

  @override
  GridScreenState createState() => GridScreenState();
}

class GridScreenState extends State<GridScreen> {
  Set<int> selectedCellIndices = {};
  late SharedPreferences prefs;
  Map<int, String> cellLabels = {};
  Map<int, String> cellLocations = {};
  Map<int, Color> cellColors = {};
  Map<int, DuplicateDetection> duplicateDetections = {};
  late TimeSettings timeSettings;
  int currentDayIndex = DateTime.now().weekday;
  final _addCellModalKey = GlobalKey<AddCellModalState>();

  @override
  void initState() {
    super.initState();
    loadSelectedCells();
  }

  void detectDuplicates(int rowCount) {
    duplicateDetections.clear();

    for (int rowIndex = 1; rowIndex < rowCount; rowIndex++) {
      for (int columnIndex = 1; columnIndex < columns; columnIndex++) {
        int cellIndex = rowIndex * columns + columnIndex;

        DuplicateDetection detection = DuplicateDetection();

        String? label = cellLabels[cellIndex]?.toLowerCase();
        String? subLabel = cellLocations[cellIndex]?.toLowerCase();
        Color? color = cellColors[cellIndex];

        for (int i = rowIndex - 1; i >= 0;) {
          int aboveCellIndex = i * columns + columnIndex;

          if (selectedCellIndices.contains(aboveCellIndex)) {
            String? aboveLabel = cellLabels[aboveCellIndex]?.toLowerCase();
            String? aboveSubLabel =
                cellLocations[aboveCellIndex]?.toLowerCase();
            Color? aboveColor = cellColors[aboveCellIndex];

            if (label == aboveLabel &&
                subLabel == aboveSubLabel &&
                color == aboveColor) {
              detection.state = DuplicateState.above;
              break;
            } else {
              break;
            }
          } else {
            break;
          }
        }

        for (int i = rowIndex + 1; i < rowCount;) {
          int belowCellIndex = i * columns + columnIndex;

          if (selectedCellIndices.contains(belowCellIndex)) {
            String? belowLabel = cellLabels[belowCellIndex]?.toLowerCase();
            String? belowSubLabel =
                cellLocations[belowCellIndex]?.toLowerCase();
            Color? belowColor = cellColors[belowCellIndex];

            if (label == belowLabel &&
                subLabel == belowSubLabel &&
                color == belowColor) {
              detection.state = detection.state == DuplicateState.above
                  ? DuplicateState.both
                  : DuplicateState.below;
              break;
            } else {
              break;
            }
          } else {
            break;
          }
        }

        duplicateDetections[cellIndex] = detection;
      }
    }
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

    String? newCellLabel = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      builder: (BuildContext context) {
        return DraggableScrollableActuator(
          child: Container(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 40),
            child: DraggableScrollableSheet(
              initialChildSize: 0.425,
              minChildSize: 0.425,
              snapSizes: const [0.425, 1.0],
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
                      onCellSaved: (label, location, color, week) {
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

  Widget _buildCell(int cellIndex) {
    String? label = cellLabels[cellIndex];
    String? subLabel = cellLocations[cellIndex];
    Color? color = cellColors[cellIndex];
    DuplicateDetection detection =
        duplicateDetections[cellIndex] ?? DuplicateDetection();
    final timeSettings = Provider.of<TimeSettings>(context, listen: false);

    int rowCount = calculateRowCount(
        timeSettings.defaultStartTime, timeSettings.defaultEndTime);

    detectDuplicates(rowCount);

    return GestureDetector(
      onTap: () {
        _showModalBottomSheet(cellIndex ~/ columns - 1, cellIndex % columns);
      },
      child: Align(
        alignment: detection.state == DuplicateState.above
            ? Alignment.topCenter
            : detection.state == DuplicateState.below
                ? Alignment.bottomCenter
                : Alignment.center,
        child: Container(
          width: 97.0,
          height: detection.state == DuplicateState.above ||
                  detection.state == DuplicateState.below
              ? 100.0
              : detection.state == DuplicateState.both
                  ? 110.0
                  : 97.0,
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                width: detection.state == DuplicateState.above ||
                        detection.state == DuplicateState.both
                    ? 0.0
                    : 1.0,
              ),
              left: const BorderSide(
                color: Colors.black,
              ),
              right: const BorderSide(
                color: Colors.black,
              ),
              bottom: BorderSide(
                width: detection.state == DuplicateState.below ||
                        detection.state == DuplicateState.both
                    ? 0.0
                    : 1.0,
              ),
            ),
            color: color,
            borderRadius: BorderRadius.only(
              topLeft: detection.state == DuplicateState.above ||
                      detection.state == DuplicateState.both
                  ? const Radius.circular(0.0)
                  : const Radius.circular(5.0),
              topRight: detection.state == DuplicateState.above ||
                      detection.state == DuplicateState.both
                  ? const Radius.circular(0.0)
                  : const Radius.circular(5.0),
              bottomLeft: detection.state == DuplicateState.below ||
                      detection.state == DuplicateState.both
                  ? const Radius.circular(0.0)
                  : const Radius.circular(5.0),
              bottomRight: detection.state == DuplicateState.below ||
                      detection.state == DuplicateState.both
                  ? const Radius.circular(0.0)
                  : const Radius.circular(5.0),
            ),
          ),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(5, 5, 5, 0),
              child: detection.state == DuplicateState.none ||
                      detection.state == DuplicateState.below
                  ? Text(
                      label.toString().length > 20
                          ? "${label.toString().substring(0, 20)}..."
                          : label.toString(),
                      style: TextStyle(
                          color: color!.computeLuminance() > .7
                              ? Colors.black
                              : Colors.white,
                          fontWeight: FontWeight.bold),
                    )
                  : null,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
              child: detection.state == DuplicateState.none ||
                      detection.state == DuplicateState.below
                  ? Text(
                      subLabel.toString().length > 20
                          ? "${subLabel.toString().substring(0, 20)}..."
                          : subLabel.toString(),
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: color!.computeLuminance() > .7
                              ? Colors.black.withOpacity(0.6)
                              : Colors.white.withOpacity(0.75),
                          fontWeight: FontWeight.bold),
                    )
                  : null,
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

    detectDuplicates(rowCount);

    List<String> times = getTimesList(context);

    if (widget.showCurrentDayCellsOnly) {
      return DayView(
        cellLabels: cellLabels,
        cellLocations: cellLocations,
        cellColors: cellColors,
      );
    } else {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            SizedBox(
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
                                  startHour:
                                      timeSettings.defaultStartTime.hour),
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
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
                                          color: const Color(0xFFB4B8AB)
                                              .withOpacity(0.5),
                                        ),
                                      ),
                              ),
                              if (selectedCellIndices.contains(index))
                                _buildCell(index)
                            ],
                          ),
                        );
                      }
                    }),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
  }
}

class DuplicateDetection {
  DuplicateState state;

  DuplicateDetection({this.state = DuplicateState.none});
}

enum DuplicateState {
  none,
  above,
  below,
  both,
}
