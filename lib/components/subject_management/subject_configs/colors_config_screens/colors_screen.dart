import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:timetable/components/subject_management/subject_configs/colors_config_screens/color_picker_screen.dart';
import 'package:timetable/components/subject_management/subject_configs/colors_config_screens/preset_colors_scren.dart';

/// Colors configuration screen, basically groups [ColorPickerScreen] and [PresetColorsScreen].
class ColorsScreen extends StatefulWidget {
  final ValueNotifier<Color> color;

  const ColorsScreen({
    super.key,
    required this.color,
  });

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
        title: const Text('choose_color').tr(),
        bottom: TabBar(
          controller: _tabController,
          tabs: <Widget>[
            Tab(
              icon: const Icon(Icons.color_lens_outlined),
              text: "presets".tr(),
            ),
            Tab(
              icon: const Icon(Icons.colorize),
              text: "custom".tr(),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          Center(
            child: PresetColorsScreen(
              color: widget.color,
            ),
          ),
          Center(
            child: ColorPickerScreen(
              color: widget.color,
            ),
          ),
        ],
      ),
    );
  }
}
