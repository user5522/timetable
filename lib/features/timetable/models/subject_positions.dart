import 'package:timetable/core/db/database.dart';

class SubjectPosition {
  final Subject subject;
  final double left;
  final double top;
  final double width;
  final double height;
  final int column;

  SubjectPosition({
    required this.subject,
    required this.left,
    required this.top,
    required this.width,
    required this.height,
    required this.column,
  });
}
