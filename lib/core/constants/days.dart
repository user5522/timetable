/// The week's days.
enum Day {
  sunday('sunday', 7),
  monday('monday', 1),
  tuesday('tuesday', 2),
  wednesday('wednesday', 3),
  thursday('thursday', 4),
  friday('friday', 5),
  saturday('saturday', 6);

  final String name;
  final int isoValue;
  const Day(this.name, this.isoValue);

  String get shortened => name.substring(0, 3);
  String get initial => name[0];
}
