import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';

part 'user_contact.g.dart';

@HiveType(typeId: 3)
class AppContact extends HiveObject {
  @HiveField(0)
  String displayName;
  @HiveField(1)
  String userId;
  @HiveField(2)
  String publicKey;

  AppContact(
      {required this.userId,
      required this.displayName,
      required this.publicKey});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> appContactjson = {};
    appContactjson['displayName'] = displayName;
    appContactjson['userId'] = userId;
    appContactjson['publicKey'] = publicKey;
    return appContactjson;
  }

  factory AppContact.fromJson(Map<String, dynamic> json) {
    return AppContact(
        userId: json['userId'],
        displayName: json['displayName'],
        publicKey: json['publicKey']);
  }
  static List<AppContact> userFromJsonString(String str) {
    List<AppContact> allContacts = List<AppContact>.from(
        json.decode(str).map((e) => AppContact.fromJson(e)));
    return allContacts;
  }
}
