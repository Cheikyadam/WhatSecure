// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_type.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MessageTypeAdapter extends TypeAdapter<MessageType> {
  @override
  final int typeId = 5;

  @override
  MessageType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return MessageType.image;
      case 1:
        return MessageType.doc;
      case 2:
        return MessageType.text;
      default:
        return MessageType.image;
    }
  }

  @override
  void write(BinaryWriter writer, MessageType obj) {
    switch (obj) {
      case MessageType.image:
        writer.writeByte(0);
        break;
      case MessageType.doc:
        writer.writeByte(1);
        break;
      case MessageType.text:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MessageTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
