part of 'subjects.dart';

class DaysAdapter extends TypeAdapter<Days> {
  @override
  final int typeId = 3;

  @override
  Days read(BinaryReader reader) {
    final value = reader.readInt();
    return Days.values[value];
  }

  @override
  void write(BinaryWriter writer, Days obj) {
    writer.writeInt(obj.index);
  }
}
