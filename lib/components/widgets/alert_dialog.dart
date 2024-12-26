import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// Alert dialog widget
class ShowAlertDialog extends StatelessWidget {
  final String? title;
  final Widget content;
  final String approveButtonText;
  final void Function()? onApprove;

  const ShowAlertDialog({
    super.key,
    this.title,
    required this.content,
    required this.approveButtonText,
    this.onApprove,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: content,
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("cancel").tr(),
        ),
        TextButton(
          onPressed: onApprove,
          child: Text(approveButtonText),
        ),
      ],
    );
  }
}
