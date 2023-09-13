import 'package:flutter/material.dart';
import 'package:timetable/models/subjects.dart';
import 'package:timetable/screens/cell_screen.dart';

class DayViewSubjectBuilder extends StatelessWidget {
  final Subject subject;

  const DayViewSubjectBuilder({super.key, required this.subject});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              settings: const RouteSettings(
                name: "CellScreen",
              ),
              builder: (context) => CellScreen(
                subject: subject,
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(10),
        child: Ink(
          decoration: BoxDecoration(
            color: subject.color,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.black),
          ),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  subject.label,
                  style: TextStyle(
                    color: subject.color.computeLuminance() > .7
                        ? Colors.black
                        : Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      "${subject.startTime.hour.toString()}:00",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        color: subject.color.computeLuminance() > .7
                            ? Colors.black.withOpacity(.6)
                            : Colors.white.withOpacity(.75),
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_rounded,
                      size: 20,
                      color: subject.color.computeLuminance() > .7
                          ? Colors.black.withOpacity(.6)
                          : Colors.white.withOpacity(.75),
                    ),
                    Text(
                      "${subject.endTime.hour.toString()}:00",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        color: subject.color.computeLuminance() > .7
                            ? Colors.black.withOpacity(.6)
                            : Colors.white.withOpacity(.75),
                      ),
                    ),
                  ],
                ),
                if (subject.location != "")
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 19,
                        color: subject.color.computeLuminance() > .7
                            ? Colors.black.withOpacity(.6)
                            : Colors.white.withOpacity(.75),
                      ),
                      Text(
                        subject.location.toString(),
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                          color: subject.color.computeLuminance() > .7
                              ? Colors.black.withOpacity(.6)
                              : Colors.white.withOpacity(.75),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
