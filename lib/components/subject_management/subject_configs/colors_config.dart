import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:timetable/components/subject_management/subject_configs/colors_config_screens/colors_screen.dart';
import 'package:timetable/components/widgets/list_item_group.dart';

/// Color configuration part of the Subject creation screen.
class ColorsConfig extends StatelessWidget {
  final ValueNotifier<Color> color;

  const ColorsConfig({
    super.key,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ListItemGroup(
      children: [
        ListItem(
          title: Row(
            children: [
              const Text("choose_color").tr(),
              const Spacer(),
              Container(
                height: 17,
                width: 17,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: color.value,
                  border: Border.all(
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              const Icon(Icons.keyboard_arrow_right)
            ],
          ),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              settings: const RouteSettings(
                name: "ColorsScreen",
              ),
              builder: (context) => ColorsScreen(color: color),
            ),
          ),
        ),
      ],
    );
  }
}
