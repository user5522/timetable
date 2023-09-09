import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:timetable/constants/colors.dart';

class ColorsScreen extends StatefulWidget {
  final ValueNotifier<Color> color;

  const ColorsScreen({
    Key? key,
    required this.color,
  }) : super(key: key);

  @override
  State<ColorsScreen> createState() => _ColorsScreenState();
}

class _ColorsScreenState extends State<ColorsScreen>
    with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose a color'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const <Widget>[
            Tab(
              icon: Icon(Icons.color_lens_outlined),
              text: "Presets",
            ),
            Tab(
              icon: Icon(Icons.colorize),
              text: "Custom",
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          Center(
            child: PresetsScreen(
              color: widget.color,
            ),
          ),
          const Center(
            child: Text("It's rainy here"),
          ),
        ],
      ),
    );
  }
}

class PresetsScreen extends HookWidget {
  final ValueNotifier<Color> color;

  const PresetsScreen({
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
