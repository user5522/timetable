import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:timetable/features/subjects/screens/colors.dart';
import 'package:timetable/shared/widgets/list_item_group.dart';

/// Color configuration part of the Subject creation screen.
class ColorsConfig extends StatelessWidget {
  /// the color that will be manipulated
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
                  border: Border.all(color: Colors.black),
                ),
              ),
              const SizedBox(width: 10),
              const Icon(Icons.keyboard_arrow_right)
            ],
          ),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ColorsScreen(color: color)),
          ),
        ),
      ],
    );
  }
}
