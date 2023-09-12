import 'package:flutter/material.dart';
import 'package:timetable/components/cell_screen_configs/colors_screen/customs_screen.dart';
import 'package:timetable/components/cell_screen_configs/colors_screen/presets_scren.dart';

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
          Center(
            child: CustomsScreen(
              color: widget.color,
            ),
          ),
        ],
      ),
    );
  }
}
