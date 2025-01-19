import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:phone_auth/controllers/get_controllers/keys_controller.dart';
import 'package:phone_auth/models/chat_model.dart';
import 'package:phone_auth/models/discussions_model.dart';
import 'package:phone_auth/models/message_type.dart';
import 'package:phone_auth/models/recognition_model.dart';
import 'package:phone_auth/models/user_contact.dart';

class DiscussionHelper {
  static const _discussion = "allggdiscussions";

  static Future<void> setupDatabase() async {
    await Hive.initFlutter();
    Hive.registerAdapter(DiscussionAdapter());
    Hive.registerAdapter(MessageTypeAdapter());
  }

  static Future<void> initAllDiscussion() async {
    // print('initCalled');
    final box = await Hive.openBox<Discussion>(_discussion);
    final KeyController keyController = Get.find<KeyController>();
    for (AppContact contact in keyController.allContact) {
      Discussion? discussion = box.get(contact.userId);
      // print(contact.userId);
      if (discussion == null) {
        // print('creation avec ${contact.displayName}');
        box.put(
            contact.userId,
            Discussion(
                discussionId: contact.userId,
                messages: [],
                unread: 0,
                displayName: contact.displayName));
      }
    }
  }

  static Future<void> createDiscussion(
      ChatMessage message, String discussionId) async {
    final box = await Hive.openBox<Discussion>(_discussion);
    final KeyController keyController = Get.find<KeyController>();
    box.put(
        discussionId,
        Discussion(
            discussionId: discussionId,
            messages: [message],
            unread: 1,
            displayName: keyController.getDisplayName(discussionId)));
  }

  static String getDiscussionId(ChatMessage message) {
    final keys = Get.find<KeyController>();
    String discussionId = message.senderId;
    if (message.senderId == keys.phone.value) {
      discussionId = message.recipientId;
    }
    return discussionId;
  }

  static Future<void> addMessageToDiscussion(
      ChatMessage message, String discussionId) async {
    //print('adding message to dis called hive helper');
    final box = await Hive.openBox<Discussion>(_discussion);
    Discussion? discussion = box.get(discussionId);
    // if (discussion == null) {
    //   createDiscussion(message, discussionId);
    // } else {
    discussion!.messages.add(message);
    discussion.unread = discussion.unread + 1;
    box.put(discussionId, discussion);
    //}
  }

  static Future<void> reinitUnread(String discussionId) async {
    final box = await Hive.openBox<Discussion>(_discussion);
    Discussion? discussion = box.get(discussionId);
    if (discussion == null) {
    } else {
      discussion.unread = 0;
      box.put(discussionId, discussion);
    }
  }

  static Future<void> updateUnread(String discussionId) async {
    final box = await Hive.openBox<Discussion>(_discussion);
    Discussion discussion = box.get(discussionId)!;
    discussion.unread = discussion.unread + 1;
    box.put(discussionId, discussion);
  }

  static Future<void> addDiscussion(Discussion discussion) async {
    final box = await Hive.openBox<Discussion>(_discussion);
    box.put(discussion.discussionId, discussion);
  }

  static Future<Map<String, Discussion>> getAllDiscussion() async {
    final box = await Hive.openBox<Discussion>(_discussion);
    //await Hive.box(_discussion).clear();
    //final box = await Hive.openBox<Discussion>(_discussion);
    //box.deleteFromDisk();
    List<Discussion> all = box.values.toList();
    List<Discussion> cpDiscussion = List.from(all);
    Map<String, Discussion> toReturn = {};
    for (Discussion discussion in cpDiscussion) {
      toReturn[discussion.discussionId] = discussion;
    }
    return toReturn;
  }
}

class ChatMessageHelper {
  static const _chatMessage = "allchats";

  static Future<void> setupDatabase() async {
    await Hive.initFlutter();
    Hive.registerAdapter(ChatMessageAdapter());
  }

  static Future<void> addMessage(ChatMessage message) async {
    final box = await Hive.openBox<ChatMessage>(_chatMessage);
    box.add(message);
  }

  static Future<List<ChatMessage>> getMessageBySenderId(String senderId) async {
    final box = await Hive.openBox<ChatMessage>(_chatMessage);
    final originalChats = box.values.toList();
    final allChats = List.from(originalChats);
    List<ChatMessage> needed = [];
    for (int i = 0; i < allChats.length; i++) {
      if (allChats[i].senderId == senderId ||
          allChats[i].recipientId == senderId) {
        needed.add(allChats[i]);
      }
    }
    return needed;
  }
}

class AppContactHelper {
  static const _contacts = "contacts";

  static Future<void> setupDatabase() async {
    await Hive.initFlutter();
    Hive.registerAdapter(AppContactAdapter());
  }

  static Future<void> addContact(AppContact contact) async {
    final box = await Hive.openBox<AppContact>(_contacts);
    box.put(contact.userId, contact);
  }

  static Future<List<AppContact>> getAllContact() async {
    final box = await Hive.openBox<AppContact>(_contacts);
    return box.values.toList();
  }

  static Future<void> deleteAppContact() async {
    final box = await Hive.openBox<AppContact>(_contacts);
    box.clear();
  }

  static Future<AppContact> getContact({required String userId}) async {
    final box = await Hive.openBox<AppContact>(_contacts);
    return box.get(userId)!;
  }
}

class RecognitionHelper {
  static const recognition = "recognitions";

  static Future<void> setupDatabase() async {
    await Hive.initFlutter();
    Hive.registerAdapter(RecognitionModelAdapter());
  }

  static Future<void> addRecognition(RecognitionModel recog) async {
    final box = await Hive.openBox<RecognitionModel>(recognition);
    box.add(recog);
  }

  static Future<List<RecognitionModel>> getAllRecognition() async {
    final box = await Hive.openBox<RecognitionModel>(recognition);
    List<RecognitionModel> all = box.values.toList();
    List<RecognitionModel> toreturn = List.from(all);
    return toreturn;
  }

  static Future<void> deleteAllFace() async {
    final box = await Hive.openBox<RecognitionModel>(recognition);
    box.deleteFromDisk();
    await Hive.openBox<RecognitionModel>(recognition);
  }
}
