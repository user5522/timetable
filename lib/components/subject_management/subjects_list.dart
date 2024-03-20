import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:timetable/components/widgets/act_chip.dart';
import 'package:timetable/components/widgets/list_item_group.dart';
import 'package:timetable/db/database.dart';

class SubjectsList extends HookWidget {
  final List<SubjectData> subjects;
  final ValueNotifier<String> value;
  final ValueNotifier<String> label;
  final ValueNotifier<String?> location;
  final ValueNotifier<Color> color;

  const SubjectsList({
    super.key,
    required this.subjects,
    required this.value,
    required this.label,
    required this.location,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<bool> labelFilterEnabled = useState(false);
    final ValueNotifier<bool> locationFilterEnabled = useState(false);
    final ValueNotifier<bool> colorFilterEnabled = useState(false);
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

    filteredSubjects = filteredSubjects.where((subject) {
      bool passesLabelFilter = !labelFilterEnabled.value ||
          subject.label.trim() == label.value.trim();
      bool passesLocationFilter = !locationFilterEnabled.value ||
          subject.location?.trim() == location.value?.trim();
      bool passesColorFilter =
          !colorFilterEnabled.value || subject.color == color.value;

      return passesLabelFilter && passesLocationFilter && passesColorFilter;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose a Subject'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Wrap(
              spacing: 4,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                const Padding(padding: EdgeInsets.only(left: 16.0)),
                const Text("Filter by:", style: TextStyle(fontSize: 17)),
                if (location.value != null && location.value!.trim().isNotEmpty)
                  ActChip(
                    label: const Text('Location'),
                    enabled: locationFilterEnabled.value,
                    onPressed: () {
                      locationFilterEnabled.value =
                          !locationFilterEnabled.value;
                    },
                  ),
                if (label.value.trim().isNotEmpty)
                  ActChip(
                    label: const Text('Label'),
                    onPressed: () {
                      labelFilterEnabled.value = !labelFilterEnabled.value;
                    },
                    enabled: labelFilterEnabled.value,
                  ),
                ActChip(
                  label: const Text('Color'),
                  enabled: colorFilterEnabled.value,
                  onPressed: () {
                    colorFilterEnabled.value = !colorFilterEnabled.value;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
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
