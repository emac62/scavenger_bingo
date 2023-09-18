// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bingo_card.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BingoCardAdapter extends TypeAdapter<BingoCard> {
  @override
  final int typeId = 0;

  @override
  BingoCard read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BingoCard(
      fields[0] as String,
      fields[1] as bool,
      (fields[2] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, BingoCard obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.canEdit)
      ..writeByte(2)
      ..write(obj.items);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BingoCardAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
