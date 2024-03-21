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

        ShapeBorder getShape(
          int index,
          int length,
        ) {
          bool isFirst = index == 0;
          bool isLast = index == length - 1;

          if (length == 1) {
            return const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            );
          }
          if (isFirst || isLast) {
            return RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(isFirst ? 10 : 5),
                bottom: Radius.circular(isFirst ? 5 : 10),
              ),
            );
          }
          return const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(5),
            ),
          );
        }

        return ListItem(
          title: e.value.title,
          subtitle: e.value.subtitle,
          leading: e.value.leading,
          trailing: e.value.trailing,
          shape: getShape(index, children.length),
          onTap: e.value.onTap,
        );
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
  final Widget? trailing;
  final VoidCallback? onTap;
  final ShapeBorder? shape;

  const ListItem({
    super.key,
    this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
    this.shape,
  });

  @override
  Widget build(BuildContext context) {
    final customTileColor = Theme.of(context).colorScheme.onInverseSurface;
    const customPadding = EdgeInsets.only(bottom: 2);

    return Column(
      children: [
        Padding(
          padding: customPadding,
          child: ListTile(
            title: title,
            subtitle: subtitle,
            leading: leading,
            onTap: onTap,
            shape: shape,
            trailing: trailing,
            tileColor: customTileColor,
          ),
        ),
      ],
    );
  }
}
