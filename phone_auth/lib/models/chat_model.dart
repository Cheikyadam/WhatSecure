import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:phone_auth/models/message_type.dart';

part 'chat_model.g.dart';

@HiveType(typeId: 1)
class ChatMessage extends HiveObject {
  ChatMessage({
    required this.fileName,
    required this.messageType,
    required this.senderId,
    required this.content,
    required this.recipientId,
  }) {
    sentAt = DateTime.now();
  }

  @HiveField(0)
  String senderId;
  @HiveField(1)
  String recipientId;
  @HiveField(2)
  String content;
  @HiveField(3)
  DateTime? sentAt;
  @HiveField(4)
  MessageType messageType;
  @HiveField(5)
  String fileName = "";

  Map<String, dynamic> toMap() {
    Map<String, dynamic> chatjson = {};
    chatjson['fileName'] = fileName;
    chatjson['senderId'] = senderId;
    chatjson['recipientId'] = recipientId;
    chatjson['content'] = content;
    chatjson['sentAt'] = sentAt!.toIso8601String();
    chatjson['messageType'] = messageType.toString().split('.').last;

    return chatjson;
  }

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      messageType: MessageType.values.firstWhere(
          (e) => e.toString() == 'MessageType.${json['messageType']}'),
      senderId: json['senderId'],
      content: json['content'],
      fileName: json['fileName'],
      recipientId: json['recipientId'],
    );
  }

  static List<ChatMessage> userFromJsonString(String str) {
    List<ChatMessage> allChats = List<ChatMessage>.from(
        json.decode(str).map((e) => ChatMessage.fromJson(e)));
    return allChats;
  }
}
