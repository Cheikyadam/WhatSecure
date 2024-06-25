import 'package:get/get.dart';
import 'package:phone_auth/controllers/hive_controller/hive_helper.dart';
import 'package:phone_auth/models/chat_model.dart';

class ChatController extends GetxController {
  final String senderId;
  final allChats = <ChatMessage>[].obs;

  void initChat(String senderId) async {
    final allOldChats =
        await (ChatMessageHelper.getMessageBySenderId(senderId));
    allChats.addAll(allOldChats);
  }

  ChatController({required this.senderId}) {
    initChat(senderId);
  }

  void addChat(ChatMessage message) async {
    allChats.add(message);
  }
}
