import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:timetable/constants/days.dart';
import 'package:hive/hive.dart';
import 'package:timetable/constants/rotation_weeks.dart';

part 'timeOfDay.g.dart';
part 'days.g.dart';
part 'subjects.g.dart';
part 'rotationWeeks.g.dart';

@immutable
@HiveType(typeId: 1)
class Subject {
  @HiveField(0)
  final String label;
  @HiveField(1)
  final String? location;
  @HiveField(2)
  final Color color;
  @HiveField(3)
  final TimeOfDay startTime;
  @HiveField(4)
  final TimeOfDay endTime;
  @HiveField(5)
  final Days day;
  @HiveField(6)
  final RotationWeeks rotationWeek;

  const Subject({
    required this.label,
    required this.location,
    required this.color,
    required this.startTime,
    required this.endTime,
    required this.day,
    required this.rotationWeek,
  });

  Subject copyWith({
    String? label,
    String? location,
    Color? color,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
    Days? day,
    RotationWeeks? rotationWeek,
  }) {
    return Subject(
      label: label ?? this.label,
      location: location ?? this.location,
      color: color ?? this.color,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      day: day ?? this.day,
      rotationWeek: rotationWeek ?? this.rotationWeek,
    );
  }
}

class SubjectNotifier extends StateNotifier<List<Subject>> {
  SubjectNotifier() : super([]) {
    loadData();
  }

  void loadData() async {
    var box = await Hive.openBox<List<dynamic>>("subjectBox");

    final subjects = box.get(0) ?? [];
    state = [...subjects];
  }

  void addSubject(Subject subject) {
    state = [...state, subject];
    saveData();
  }

  void removeSubject(Subject subject) {
    state = state.where((s) => s != subject).toList();
    saveData();
  }

  void updateSubject(Subject oldSubject, Subject newSubject) {
    state = [
      for (final subject in state)
        if (subject == oldSubject)
          subject.copyWith(
            label: newSubject.label,
            location: newSubject.location,
            color: newSubject.color,
            startTime: newSubject.startTime,
            endTime: newSubject.endTime,
            day: newSubject.day,
            rotationWeek: newSubject.rotationWeek,
          )
        else
          subject,
    ];
  }

  void saveData() async {
    var box = await Hive.openBox<List<dynamic>>("subjectBox");

    try {
      box.putAt(0, state);
    } catch (e) {
      box.add(state);
    }
  }
}

final subjectProvider = StateNotifierProvider<SubjectNotifier, List<Subject>>(
  (ref) => SubjectNotifier(),
);
