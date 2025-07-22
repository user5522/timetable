/// Basic Rotation Weeks definition.
enum RotationWeeks {
  none("all"),
  a("A"),
  b("B");

  final String name;
  const RotationWeeks(this.name);

  String get displayName => name == "all" ? "" : name;
}
