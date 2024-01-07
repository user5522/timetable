import 'package:flutter/material.dart';

/// Custom Widget to handle the look of a List of ListTiles.
///
/// ```dart
/// ListItemGroup(
///   children: [
///     // only accepts children of the type [ListItem]
///     ListItem(
///       title: "Title",
///     ),
///   ],
/// );
/// ```
class ListItemGroup extends StatelessWidget {
  final List<ListItem> children;

  const ListItemGroup({
    super.key,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: children.asMap().entries.map((e) {
        final index = e.key;
        bool first = index == 0;
        bool last = index == children.length - 1;
        if (children.length > 1 && (first || last)) {
          return ListItem(
            title: e.value.title,
            subtitle: e.value.subtitle,
            leading: e.value.leading,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(first ? 10 : 5),
                bottom: Radius.circular(first ? 5 : 10),
              ),
            ),
            onTap: () => e.value.onTap,
          );
        } else {
          return ListItem(
            title: e.value.title,
            subtitle: e.value.subtitle,
            leading: e.value.leading,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(5),
              ),
            ),
            onTap: () => e.value.onTap,
          );
        }
      }).toList(),
    );
  }
}

/// Basically a worse version of ListTile that's needed for aesthetics.
///
/// ```dart
/// ListItem(
///   title: "Title",
/// );
/// ```
class ListItem extends StatelessWidget {
  final Widget? title;
  final Widget? subtitle;
  final Widget? leading;
  final GestureTapCallback? onTap;
  final ShapeBorder? shape;
  final String? hintText;

  const ListItem({
    super.key,
    this.title,
    this.subtitle,
    this.leading,
    this.onTap,
    this.shape,
    this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 2),
          child: ListTile(
            title: title,
            subtitle: subtitle,
            leading: leading,
            onTap: () => onTap,
            shape: shape,
            tileColor: Theme.of(context).colorScheme.surfaceVariant,
          ),
        ),
      ],
    );
  }
}
