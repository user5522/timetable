import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:timetable/components/widgets/list_tile_group.dart';

class NotesTile extends ConsumerWidget {
  final ValueNotifier<String?> note;

  const NotesTile({
    super.key,
    required this.note,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListItem(
      title: TextFormField(
        initialValue: note.value,
        decoration: const InputDecoration(
          hintText: "Notes",
          border: InputBorder.none,
        ),
        maxLines: 3,
        maxLength: 100,
        onChanged: (value) {
          note.value = value;
        },
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
    );
  }
}
