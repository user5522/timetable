import 'package:flutter/material.dart';
import 'package:timetable/components/subject_management/subjects_list.dart';
import 'package:timetable/components/widgets/list_item_group.dart';
import 'package:timetable/constants/basic_subject.dart';
import 'package:timetable/db/database.dart';

class LabelLocationConfig extends StatefulWidget {
  final List<SubjectData> subjects;
  final ValueNotifier<String> label;
  final ValueNotifier<String?> location;
  final ValueNotifier<Color> color;
  final bool autoCompleteColor;

  const LabelLocationConfig({
    super.key,
    required this.subjects,
    required this.label,
    required this.location,
    required this.color,
    required this.autoCompleteColor,
  });

  @override
  State<LabelLocationConfig> createState() => _LabelLocationConfigState();
}

class _LabelLocationConfigState extends State<LabelLocationConfig> {
  late FocusNode locationFieldFocusNode;

  @override
  void initState() {
    super.initState();

    locationFieldFocusNode = FocusNode();
  }

  @override
  void dispose() {
    locationFieldFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListItemGroup(
      children: [
        ListItem(
          title: TextFormField(
            // key: Key(widget.label.value),
            initialValue: widget.label.value,
            autofocus: true,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              hintText: "Subject",
              border: InputBorder.none,
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter a Subject.';
              }
              return null;
            },
            onChanged: (value) {
              widget.label.value = value;
              if (widget.autoCompleteColor) {
                widget.color.value = widget.subjects
                    .firstWhere(
                      (subj) =>
                          widget.label.value.toLowerCase().trim() ==
                          subj.label.toLowerCase().trim(),
                      orElse: () => basicSubject,
                    )
                    .color;
              }
            },
            onEditingComplete: () => locationFieldFocusNode.requestFocus(),
          ),
          trailing: widget.subjects.isNotEmpty
              ? IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        settings: const RouteSettings(
                          name: "SubjectsList",
                        ),
                        builder: (context) => SubjectsList(
                          subjects: widget.subjects,
                          value: widget.label,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.more_horiz),
                )
              : null,
        ),
        ListItem(
          title: TextFormField(
            focusNode: locationFieldFocusNode,
            initialValue: widget.location.value,
            textInputAction: TextInputAction.done,
            decoration: const InputDecoration(
              hintText: "Location",
              border: InputBorder.none,
            ),
            onChanged: (value) {
              widget.location.value = value;
            },
          ),
        ),
      ],
    );
  }
}
