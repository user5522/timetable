import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:timetable/features/timetable/providers/timetables.dart';
import 'package:timetable/features/subjects/providers/subjects.dart';

/// https://riverpod.dev/docs/essentials/eager_initialization
///
/// "All providers are initialized lazily by default.
/// One solution is to forcibly read the providers you want to eagerly initialize."
class EagerInitialization extends ConsumerWidget {
  final Widget child;

  const EagerInitialization({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(timetableProvider);
    ref.read(subjectProvider);
    final timetablesNotifier = ref.watch(timetableProvider.notifier);

    return FutureBuilder(
      future: timetablesNotifier.fetchTimetablesFromDatabase(),
      builder: (context, snapshot) {
        if (snapshot.hasData) return child;
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
