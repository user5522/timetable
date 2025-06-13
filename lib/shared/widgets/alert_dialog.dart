import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:timetable/shared/widgets/list_item_group.dart';

/// Alert dialog widget
class ShowAlertDialog extends StatelessWidget {
  final String? title;
  final Widget content;
  final Widget? leading;
  final String approveButtonText;
  final void Function()? onApprove;
  final void Function()? onCancel;

  const ShowAlertDialog({
    super.key,
    this.title,
    required this.content,
    required this.approveButtonText,
    this.onApprove,
    this.onCancel,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    /// default style for the content text
    Widget modifiedContent = content is Text
        ? Text((content as Text).data ?? '', textAlign: TextAlign.center)
        : content;

    return AlertDialog(
      icon: const Icon(Icons.warning_amber_outlined, size: 30),
      content: modifiedContent,
      contentTextStyle: TextStyle(
        fontSize: 20,
        color: Theme.of(context).textTheme.titleMedium!.color,
      ),
      actions: <Widget>[
        ListItemGroup(
          children: [
            ListItem(
              onTap: onCancel,
              title: const Text("cancel", textAlign: TextAlign.center).tr(),
            ),
            ListItem(
              leading: leading,
              onTap: onApprove,
              title: Text(
                approveButtonText,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.onErrorContainer,
                ),
              ),
              tileColor: Theme.of(context).colorScheme.error.withAlpha(50),
            ),
          ],
        ),
      ],
    );
  }
}
