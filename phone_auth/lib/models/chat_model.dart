import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';

part 'chat_model.g.dart';

@HiveType(typeId: 1)
class ChatMessage extends HiveObject {
  //String? chatId;
  ChatMessage({
    required this.senderId,
    required this.content,
    required this.recipientId,
  }) {
    sentAt = DateTime.now();
  }

  @HiveField(0)
  String? senderId;
  @HiveField(1)
  String? recipientId;
  @HiveField(2)
  String? content;
  @HiveField(3)
  DateTime? sentAt;

  Map<String, dynamic> toMap() {
    Map<String, dynamic> chatjson = {};
    chatjson['senderId'] = senderId;
    chatjson['recipientId'] = recipientId;
    chatjson['content'] = content;
    chatjson['sentAt'] = sentAt!.toIso8601String();

    return chatjson;
  }

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      senderId: json['senderId'],
      content: json['content'],
      recipientId: json['recipientId'],
    );
  }

  static List<ChatMessage> userFromJsonString(String str) {
    List<ChatMessage> allChats = List<ChatMessage>.from(
        json.decode(str).map((e) => ChatMessage.fromJson(e)));
    return allChats;
  }
}
