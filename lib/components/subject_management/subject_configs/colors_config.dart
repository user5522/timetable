import 'package:flutter/material.dart';
import 'package:timetable/components/subject_management/subject_configs/colors_config_screens/colors_screen.dart';

/// Color configuration part of the Subject creation screen.
class ColorsConfig extends StatelessWidget {
  final ValueNotifier<Color> color;

  const ColorsConfig({
    super.key,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        children: [
          const Text("Choose a color"),
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
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      tileColor: Theme.of(context).colorScheme.surfaceVariant,
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          settings: const RouteSettings(
            name: "ColorsScreen",
          ),
          builder: (context) => ColorsScreen(color: color),
        ),
      ),
    );
  }
}
