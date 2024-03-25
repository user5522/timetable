import 'package:easy_localization/easy_localization.dart';
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
  late TextEditingController labelController;

  @override
  void initState() {
    super.initState();
    labelController = TextEditingController(text: widget.label.value);
    locationFieldFocusNode = FocusNode();
  }

  @override
  void dispose() {
    labelController.dispose();
    locationFieldFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListItemGroup(
      children: [
        ListItem(
          title: TextFormField(
            autofocus: true,
            controller: labelController,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              hintText: "subject".tr(),
              border: InputBorder.none,
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'subject_input_error'.tr();
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
                          label: widget.label,
                          location: widget.location,
                          color: widget.color,
                          controller: labelController,
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
            decoration: InputDecoration(
              hintText: "location".tr(),
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
