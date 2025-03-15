import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:timetable/components/widgets/color_indicator.dart';
import 'package:timetable/components/widgets/list_item_group.dart';
import 'package:timetable/constants/error_emoticons.dart';
import 'package:timetable/db/database.dart';

/// lists all subjects to choose a label &
/// color from an already existing one
class SubjectsList extends HookWidget {
  final List<SubjectData> subjects;
  final TextEditingController controller;
  final ValueNotifier<String> label;
  final ValueNotifier<String?> location;
  final ValueNotifier<Color> color;

  const SubjectsList({
    super.key,
    required this.subjects,
    required this.controller,
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

    /// places 1 subject from duplicates in a set (filtered by label)
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
        title: const Text('choose_subject').tr(),
        actions: [
          // filtering system
          MenuAnchor(
            menuChildren: <Widget>[
              CheckboxMenuButton(
                value: labelFilterEnabled.value,
                onChanged: (value) => labelFilterEnabled.value = value ?? false,
                child: const Text('Label').tr(),
              ),
              CheckboxMenuButton(
                value: locationFilterEnabled.value,
                onChanged: (value) =>
                    locationFilterEnabled.value = value ?? false,
                child: const Text('Location').tr(),
              ),
              CheckboxMenuButton(
                value: colorFilterEnabled.value,
                onChanged: (value) => colorFilterEnabled.value = value ?? false,
                child: const Text('Color').tr(),
              ),
            ],
            builder: (
              BuildContext context,
              MenuController controller,
              Widget? child,
            ) {
              return IconButton(
                icon: const Icon(Icons.filter_list_outlined),
                tooltip: "filter_by".tr(),
                onPressed: () {
                  if (controller.isOpen) {
                    controller.close();
                  } else {
                    controller.open();
                  }
                },
              );
            },
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            if (filteredSubjects.isEmpty)
              Container(
                padding: const EdgeInsets.all(10),
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: Center(
                  child: Column(
                    children: [
                      Text(
                        getRandomErrorEmoticon(),
                        style: const TextStyle(fontSize: 25),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "no_subjects_error",
                        style: TextStyle(fontSize: 18),
                      ).tr(),
                    ],
                  ),
                ),
              ),
            if (filteredSubjects.isNotEmpty)
              ListItemGroup(
                children: List.generate(filteredSubjects.length, (i) {
                  final subj = filteredSubjects[i];
                  return ListItem(
                    leading: ColorIndicator(color: subj.color),
                    title: Text(subj.label),
                    subtitle: (subj.location != null &&
                                subj.location!.isNotEmpty) ||
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
                      controller.text = subj.label;
                      label.value = subj.label;
                      color.value = subj.color;
                      Navigator.of(context).pop();
                    },
                  );
                }),
              ),
          ],
        ),
      ),
    );
  }
}
