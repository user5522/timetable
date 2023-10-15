import 'package:flutter/material.dart';

/// Custom Widget to handle the look of a List of ListTiles.
class ListTileGroup extends StatelessWidget {
  final List<ListItem> children;

  const ListTileGroup({
    super.key,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: children.asMap().entries.map((e) {
        final index = e.key;
        if (index == 0 && children.length > 1) {
          return ListItem(
            title: e.value.title,
            subtitle: e.value.subtitle,
            leading: e.value.leading,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(10),
                bottom: Radius.circular(5),
              ),
            ),
            onTap: () => e.value.onTap,
          );
        } else if (index == children.length - 1 && children.length > 1) {
          return ListItem(
            title: e.value.title,
            subtitle: e.value.subtitle,
            leading: e.value.leading,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(5),
                bottom: Radius.circular(10),
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
        ListTile(
          title: title,
          subtitle: subtitle,
          leading: leading,
          onTap: () {
            onTap;
          },
          shape: shape,
          tileColor: Theme.of(context).colorScheme.surfaceVariant,
        ),
        const SizedBox(
          height: 2,
        ),
      ],
    );
  }
}
