// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'discussions_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DiscussionAdapter extends TypeAdapter<Discussion> {
  @override
  final int typeId = 2;

  @override
  Discussion read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Discussion(
      senderId: fields[0] as String,
      lastMessage: fields[2] as ChatMessage,
      unread: fields[1] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Discussion obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.senderId)
      ..writeByte(1)
      ..write(obj.unread)
      ..writeByte(2)
      ..write(obj.lastMessage);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DiscussionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
