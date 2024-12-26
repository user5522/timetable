import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:timetable/components/subject_management/subjects_list.dart';
import 'package:timetable/components/widgets/list_item_group.dart';
import 'package:timetable/constants/basic_subject.dart';
import 'package:timetable/db/database.dart';
import 'package:timetable/helpers/route_helper.dart';

/// Label & Location configuration part of the Subject creation screen.
///
/// Groups the label (+ the [SubjectsList] button) & the
/// location [TextFormField]s in a [ListItemGroup].
class LabelLocationConfig extends StatefulWidget {
  final List<SubjectData> subjects;
  final ValueNotifier<String> label;
  final ValueNotifier<String?> location;

  /// color is used for the color auto complete feature
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
  // bro this text field focusing stuff took for fucking ever to get working properly
  late FocusNode locationFieldFocusNode;

  /// handles the label [TextFormField] initial value and refreshes the widget
  /// if changed from [SubjectsList]
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
                      RouteHelper(
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
