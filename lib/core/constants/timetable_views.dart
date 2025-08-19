import 'package:easy_localization/easy_localization.dart';

/// Timetable Views
enum TbViews {
  grid("grid"),
  day("day");

  final String name;
  const TbViews(this.name);

  String get label => name.tr();
}
