// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recognition_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RecognitionModelAdapter extends TypeAdapter<RecognitionModel> {
  @override
  final int typeId = 4;

  @override
  RecognitionModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RecognitionModel(
      name: fields[0] as String,
      embeddings: (fields[1] as List).cast<double>(),
    );
  }

  @override
  void write(BinaryWriter writer, RecognitionModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.embeddings);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecognitionModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
