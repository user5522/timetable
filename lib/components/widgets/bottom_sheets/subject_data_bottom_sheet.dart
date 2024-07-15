import 'package:flutter/material.dart';

/// Bottom sheet widget with a title and a list of children.
class SubjectDataBottomSheet extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const SubjectDataBottomSheet({
    super.key,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
          child: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        ListView(
          shrinkWrap: true,
          primary: false,
          children: children,
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
