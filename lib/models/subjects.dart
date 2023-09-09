import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:timetable/constants/days.dart';

@immutable
class Subject {
  final String label;
  final String? location;
  final Color color;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final Days day;

  const Subject({
    required this.label,
    required this.location,
    required this.color,
    required this.startTime,
    required this.endTime,
    required this.day,
  });

  Subject copyWith({
    String? label,
    String? location,
    Color? color,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
    Days? day,
  }) {
    return Subject(
      label: label ?? this.label,
      location: location ?? this.location,
      color: color ?? this.color,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      day: day ?? this.day,
    );
  }
}

class SubjectNotifier extends StateNotifier<List<Subject>> {
  SubjectNotifier() : super([]);

  void addSubject(Subject subject) {
    state = [...state, subject];
  }

  void removeSubject(Subject subject) {
    state = state.where((s) => s.label != subject.label).toList();
  }

  void updateSubject(Subject subject, Subject newSubject) {
    state = state
        .map(
          (s) => s.copyWith(
            startTime: newSubject.startTime,
            endTime: newSubject.endTime,
          ),
        )
        .toList();
  }

  // void function to change an inputted subject's label
  void changeSubjectLabel(Subject subject, String newLabel) {
    subject.copyWith(label: newLabel);
  }
}

final subjectProvider = StateNotifierProvider<SubjectNotifier, List<Subject>>(
  (ref) => SubjectNotifier(),
);
