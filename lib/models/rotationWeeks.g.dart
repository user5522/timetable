part of 'subjects.dart';

class RotationWeeksAdapter extends TypeAdapter<RotationWeeks> {
  @override
  final int typeId = 4;

  @override
  RotationWeeks read(BinaryReader reader) {
    final value = reader.readInt();
    return RotationWeeks.values[value];
  }

  @override
  void write(BinaryWriter writer, RotationWeeks obj) {
    writer.writeInt(obj.index);
  }
}
