import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:phone_auth/models/chat_model.dart';
part 'discussions_model.g.dart';

@HiveType(typeId: 2)
class Discussion extends HiveObject {
  @HiveField(0)
  String discussionId;
  @HiveField(1)
  int unread = 0;
  @HiveField(2)
  List<ChatMessage> messages;
  @HiveField(3)
  String displayName;

  Discussion(
      {required this.discussionId,
      required this.messages,
      required this.unread,
      required this.displayName});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> discussionjson = {};
    discussionjson['discussionId'] = discussionId;
    discussionjson['messages'] = messages;
    discussionjson['displayName'] = displayName;
    return discussionjson;
  }

  factory Discussion.fromJson(Map<String, dynamic> json) {
    return Discussion(
        discussionId: json['discussionId'],
        messages: json['messages'],
        unread: json['unread'],
        displayName: json['displayName']);
  }
  static List<Discussion> userFromJsonString(String str) {
    List<Discussion> allDiscussions = List<Discussion>.from(
        json.decode(str).map((e) => Discussion.fromJson(e)));
    return allDiscussions;
  }
}
