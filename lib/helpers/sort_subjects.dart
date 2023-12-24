import 'package:timetable/db/database.dart';

List<SubjectData> sortSubjects(List<SubjectData> subjects) {
  subjects.sort((a, b) => a.startTime.hour.compareTo(b.startTime.hour));

  return subjects;
}
