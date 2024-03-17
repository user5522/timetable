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
    Set<String> uniqueSubjects = {};

    // remove duplicate subjects by label
    List<SubjectData> filteredSubjects = [];
    for (SubjectData subject in subjects) {
      final label = subject.label;

      if (!uniqueSubjects.contains(label)) {
        uniqueSubjects.add(label);
        filteredSubjects.add(subject);
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Choose a Subject')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ListItemGroup(
            children: List.generate(filteredSubjects.length, (i) {
              final subj = filteredSubjects[i];
              return ListItem(
                leading: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: subj.color,
                  ),
                  width: 15,
                  height: 15,
                ),
                title: Text(subj.label),
                subtitle:
                    (subj.location != null && subj.location!.isNotEmpty) ||
                            (subj.note != null && subj.note!.isNotEmpty)
                        ? Column(
                            children: [
                              if (subj.location != null &&
                                  subj.location!.isNotEmpty)
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.location_on_outlined,
                                      size: 15,
                                    ),
                                    const SizedBox(width: 2.5),
                                    Expanded(
                                      child: Text(
                                        subj.location.toString(),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              if (subj.note != null && subj.note!.isNotEmpty)
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.sticky_note_2_outlined,
                                      size: 15,
                                    ),
                                    const SizedBox(width: 2.5),
                                    Expanded(
                                      child: Text(
                                        subj.note.toString(),
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
                  value.value = subj.label;
                  Navigator.of(context).pop();
                },
              );
            }),
          ),
        ),
      ),
    );
  }
}
