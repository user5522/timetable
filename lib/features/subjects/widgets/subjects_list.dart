import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:timetable/shared/widgets/color_indicator.dart';
import 'package:timetable/shared/widgets/list_item_group.dart';
import 'package:timetable/core/constants/error_emoticons.dart';
import 'package:timetable/core/db/database.dart';

/// lists all subjects to choose a label &
/// color from an already existing one
class SubjectsList extends HookWidget {
  final List<Subject> subjects;
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
    List<Subject> filteredSubjects = [];
    for (Subject subject in subjects) {
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
          buildFilterMenuAnchor(
            labelFilterEnabled: labelFilterEnabled,
            locationFilterEnabled: locationFilterEnabled,
            colorFilterEnabled: colorFilterEnabled,
          )
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
              buildSubjectsList(
                filteredSubjects: filteredSubjects,
                navigator: Navigator.of(context),
              )
          ],
        ),
      ),
    );
  }

  Widget buildSubjectsList({
    required NavigatorState navigator,
    required List<Subject> filteredSubjects,
  }) {
    return ListItemGroup(
      children: List.generate(filteredSubjects.length, (i) {
        final subj = filteredSubjects[i];
        final location = subj.location;
        final note = subj.note;

        return ListItem(
          leading: ColorIndicator(color: subj.color),
          title: Text(subj.label),
          subtitle: (location != null && location.isNotEmpty) ||
                  (note != null && note.isNotEmpty)
              ? Column(
                  children: [
                    if (location != null && location.isNotEmpty)
                      buildSubjectListDataRow(
                        icon: Icons.location_on_outlined,
                        text: subj.location!,
                        maxLines: 2,
                      ),
                    if (note != null && note.isNotEmpty)
                      buildSubjectListDataRow(
                        icon: Icons.sticky_note_2_outlined,
                        text: subj.note!,
                        maxLines: 4,
                      ),
                  ],
                )
              : null,
          onTap: () {
            controller.text = subj.label;
            label.value = subj.label;
            color.value = subj.color;
            navigator.pop();
          },
        );
      }),
    );
  }

  Widget buildSubjectListDataRow({
    required String text,
    required IconData icon,
    required int maxLines,
  }) {
    return Row(
      children: [
        Icon(icon, size: 15),
        const SizedBox(width: 2.5),
        Expanded(
          child: Text(
            text,
            maxLines: maxLines,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }

  Widget buildFilterMenuAnchor({
    required ValueNotifier<bool> labelFilterEnabled,
    required ValueNotifier<bool> locationFilterEnabled,
    required ValueNotifier<bool> colorFilterEnabled,
  }) {
    return MenuAnchor(
      menuChildren: <Widget>[
        CheckboxMenuButton(
          value: labelFilterEnabled.value,
          onChanged: (value) => labelFilterEnabled.value = value ?? false,
          child: const Text('Label').tr(),
        ),
        CheckboxMenuButton(
          value: locationFilterEnabled.value,
          onChanged: (value) => locationFilterEnabled.value = value ?? false,
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
            if (controller.isOpen) controller.close();
            controller.open();
          },
        );
      },
    );
  }
}
