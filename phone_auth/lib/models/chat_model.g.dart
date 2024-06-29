// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChatMessageAdapter extends TypeAdapter<ChatMessage> {
  @override
  final int typeId = 1;

  @override
  ChatMessage read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChatMessage(
      fileName: fields[5] as String,
      messageType: fields[4] as MessageType,
      senderId: fields[0] as String,
      content: fields[2] as String,
      recipientId: fields[1] as String,
    )..sentAt = fields[3] as DateTime?;
  }

  @override
  void write(BinaryWriter writer, ChatMessage obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.senderId)
      ..writeByte(1)
      ..write(obj.recipientId)
      ..writeByte(2)
      ..write(obj.content)
      ..writeByte(3)
      ..write(obj.sentAt)
      ..writeByte(4)
      ..write(obj.messageType)
      ..writeByte(5)
      ..write(obj.fileName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatMessageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
