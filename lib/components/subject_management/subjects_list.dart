import 'package:flutter/material.dart';
import 'package:timetable/components/widgets/list_item_group.dart';
import 'package:timetable/db/database.dart';

class SubjectsList extends StatelessWidget {
  final List<SubjectData> subjects;
  final ValueNotifier<String> value;

  const SubjectsList({
    super.key,
    required this.subjects,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Choose a Subject')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ListItemGroup(
            children: subjects
                .map(
                  (e) => ListItem(
                    leading: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: e.color,
                      ),
                      width: 15,
                      height: 15,
                    ),
                    title: Text(e.label),
                    subtitle: (e.location != null && e.location!.isNotEmpty) ||
                            (e.note != null && e.note!.isNotEmpty)
                        ? Column(
                            children: [
                              if (e.location != null && e.location!.isNotEmpty)
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.location_on_outlined,
                                      size: 15,
                                    ),
                                    const SizedBox(width: 2.5),
                                    Expanded(
                                      child: Text(
                                        e.location.toString(),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              if (e.note != null && e.note!.isNotEmpty)
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.sticky_note_2_outlined,
                                      size: 15,
                                    ),
                                    const SizedBox(width: 2.5),
                                    Expanded(
                                      child: Text(
                                        e.note.toString(),
                                        maxLines: 4,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          )
                        : null,
                    onTap: () {
                      value.value = e.label;
                      Navigator.of(context).pop();
                    },
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}
