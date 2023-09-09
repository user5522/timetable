import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:timetable/models/settings.dart';
import 'package:timetable/models/subjects.dart';

class SubjectBuilder extends ConsumerWidget {
  final Subject subject;

  const SubjectBuilder({
    super.key,
    required this.subject,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hideLocation = ref.watch(settingsProvider).hideLocation;
    String label = subject.label;
    String? location = subject.location;
    Color color = subject.color;

    Color labelColor =
        color.computeLuminance() > .7 ? Colors.black : Colors.white;
    Color subLabelsColor = color.computeLuminance() > .7
        ? Colors.black.withOpacity(.6)
        : Colors.white.withOpacity(.75);

    return Padding(
      padding: const EdgeInsets.all(2),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(5),
        child: Ink(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: color,
            border: Border.all(color: Colors.black, width: 1),
            borderRadius: const BorderRadius.all(
              Radius.circular(5),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: labelColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if ((location != null))
                if (hideLocation == false)
                  Text(
                    location.toString(),
                    style: TextStyle(
                      color: subLabelsColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
