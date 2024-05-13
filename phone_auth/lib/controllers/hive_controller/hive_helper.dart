import 'package:hive_flutter/hive_flutter.dart';
import 'package:phone_auth/models/chat_model.dart';
import 'package:phone_auth/models/discussions_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

import 'package:phone_auth/models/user_contact.dart';

class DiscussionHelper {
  static const _discussion = "discussions";

  static Future<List<int>> getKey() async {
    AndroidOptions getAndroidOptions() => const AndroidOptions(
          encryptedSharedPreferences: true,
        );
    final storage = FlutterSecureStorage(aOptions: getAndroidOptions());

    String? value = await storage.read(key: 'hiveKey');

    final keyBytes = base64.decode(value!);

    return keyBytes;
  }

  static Future<void> setupDatabase() async {
    await Hive.initFlutter();
    Hive.registerAdapter(DiscussionAdapter());
  }

  static Future<void> addDiscussion(Discussion discussion) async {
    //final key = await getKey();
    final box = await Hive.openBox<Discussion>(_discussion);
    // encryptionCipher: HiveAesCipher(key));
    box.put(discussion.senderId, discussion);
  }

  static Future<List<Discussion>> getAllDiscussion() async {
    //final key = await getKey();
    final box = await Hive.openBox<Discussion>(_discussion);
    //box.clear();
    // encryptionCipher: HiveAesCipher(key));
    //box.deleteFromDisk();
    List<Discussion> all = box.values.toList();
    // box.close();
    List<Discussion> toreturn = List.from(all);
    //print("CHECKING");
    /*for (var dis in all) {
      print(dis.lastMessage.content);
    }
    print("CHECKING");*/
    // box.close();
    return toreturn;
  }
}

class ChatMessageHelper {
  static const _chatMessage = "chats";

  static Future<void> setupDatabase() async {
    await Hive.initFlutter();
    Hive.registerAdapter(ChatMessageAdapter());
  }

  static Future<void> addMessage(ChatMessage message) async {
    // final key = await DiscussionHelper.getKey();
    final box = await Hive.openBox<ChatMessage>(_chatMessage);

    // encryptionCipher: HiveAesCipher(key));

    // print("+++++++++++++++ADDDDDDEEEEEEEEEEEEEEEDDDDDDDDDDDDDDDDDDDDDD");
    //message.save();
    box.add(message);
    //box.close();
  }

  static Future<List<ChatMessage>> getMessageBySenderId(String senderId) async {
    //final key = await DiscussionHelper.getKey();
    final box = await Hive.openBox<ChatMessage>(_chatMessage);
    //box.clear();
    // encryptionCipher: HiveAesCipher(key));
    //box.deleteFromDisk();

    final originalChats = box.values.toList();

    final allChats = List.from(originalChats);
    List<ChatMessage> needed = [];

    for (int i = 0; i < allChats.length; i++) {
      if (allChats[i].senderId == senderId ||
          allChats[i].recipientId == senderId) {
        // String decrypted = await Encryption.decryptMessage(
        //     encodedMessage: allChats[i].content!);
        // // print("DECRYPED****************$decrypted*******************DECRYPTED");
        // allChats[i].content = decrypted;
        needed.add(allChats[i]);
      }
    }
    //print(
    //  "NEEEDED==========================$needed====================================NEEDED");
    //print(needed);
    //print("==============================================================");

    //print("CHECKING MESSAGE");

    /*for (var val in needed) {
      print(val.content);
    }*/

    //print("CHECKING MESSAGE");
    return needed;
    /*.takeWhile((value) =>
            value.senderId == senderId || (value.recipientId == senderId))
        .toList();
  }*/
  }
}

class AppContactHelper {
  static const _contacts = "contacts";

  static Future<List<int>> getKey() async {
    AndroidOptions getAndroidOptions() => const AndroidOptions(
          encryptedSharedPreferences: true,
        );
    final storage = FlutterSecureStorage(aOptions: getAndroidOptions());

    String? value = await storage.read(key: 'hiveKey');

    final keyBytes = base64.decode(value!);

    return keyBytes;
  }

  static Future<void> setupDatabase() async {
    await Hive.initFlutter();
    Hive.registerAdapter(AppContactAdapter());
  }

  static Future<void> addContact(AppContact contact) async {
    //final key = await getKey();
    final box = await Hive.openBox<AppContact>(_contacts);
    // encryptionCipher: HiveAesCipher(key));
    //contact.save();
    box.put(contact.userId, contact);
  }

  static Future<List<AppContact>> getAllContact() async {
    //final key = await getKey();
    final box = await Hive.openBox<AppContact>(_contacts);
    // encryptionCipher: HiveAesCipher(key));
    //box.deleteFromDisk();
    print("tester");
    print(box.values.first.displayName);
    return box.values.toList();
  }

  static Future<AppContact> getContact({required String userId}) async {
    final box = await Hive.openBox<AppContact>(_contacts);

    return box.get(userId)!;
  }
}
