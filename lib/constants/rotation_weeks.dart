enum RotationWeeks {
  all,
  none,
  a,
  b,
}

String getRotationWeekLabel(RotationWeeks rotationWeek) {
  switch (rotationWeek) {
    case RotationWeeks.none:
      return "All Weeks";
    case RotationWeeks.a:
      return "Week A";
    case RotationWeeks.b:
      return "Week B";
    default:
      return "All Weeks";
  }
}
