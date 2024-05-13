import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:phone_auth/models/chat_model.dart';
part 'discussions_model.g.dart';

@HiveType(typeId: 2)
class Discussion extends HiveObject {
  @HiveField(0)
  String senderId;
  @HiveField(1)
  int unread = 0;
  @HiveField(2)
  ChatMessage lastMessage;
  Discussion(
      {required this.senderId,
      required this.lastMessage,
      required this.unread});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> discussionjson = {};
    discussionjson['senderId'] = senderId;
    discussionjson['lastMessage'] = lastMessage;
    return discussionjson;
  }

  factory Discussion.fromJson(Map<String, dynamic> json) {
    return Discussion(
        senderId: json['senderId'],
        lastMessage: json['lastMessage'],
        unread: json['unread']);
  }
  static List<Discussion> userFromJsonString(String str) {
    List<Discussion> allDiscussions = List<Discussion>.from(
        json.decode(str).map((e) => Discussion.fromJson(e)));
    return allDiscussions;
  }
}
