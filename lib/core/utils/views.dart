import 'package:easy_localization/easy_localization.dart';
import 'package:timetable/core/constants/timetable_views.dart';

/// for each value of the enum it will give a corresponding label.
String getViewLabel(TbViews view) {
  switch (view) {
    case TbViews.grid:
      return 'grid'.tr();
    case TbViews.day:
      return 'day'.plural(1);
  }
}
