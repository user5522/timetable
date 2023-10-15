import 'package:flutter/material.dart';
import 'package:timetable/constants/days.dart';

/// Bottom Sheet Modal Widget used to select a subject's day.
class DaysModalBottomSheet extends StatelessWidget {
  final List<Days> days;
  final ValueNotifier<Days> day;

  const DaysModalBottomSheet(
      {super.key, required this.days, required this.day});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
          child: Text(
            "Week days",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        ListView(
          shrinkWrap: true,
          primary: false,
          children: days.map(
            (e) {
              return ListTile(
                title: Text(
                  e.name[0].toUpperCase() + e.name.substring(1).toLowerCase(),
                ),
                visualDensity: VisualDensity.compact,
                onTap: () {
                  day.value = e;
                  Navigator.pop(context);
                },
              );
            },
          ).toList(),
        ),
      ],
    );
  }
}
