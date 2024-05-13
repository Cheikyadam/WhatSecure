import 'package:get/get.dart';
import 'package:phone_auth/controllers/hive_controller/hive_helper.dart';
import 'package:phone_auth/models/chat_model.dart';

class ChatController extends GetxController {
  final String senderId;
  final allChats = <ChatMessage>[].obs;

  void initChat(String senderId) async {
    /*final constantsService = ConstantsService();
    await constantsService.initConstants();
    final privateKey = constantsService.privateKey;*/

    final allOldChats =
        await (ChatMessageHelper.getMessageBySenderId(senderId));

    /*for (var chat in allOldChats) {
      String decrypted = Encryption.decryptMessage(
          encodedMessage: chat.content!, privateKey: privateKey);
      //print("DECRYPED****************$decrypted*******************DECRYPTED");
      chat.content = decrypted;
    }*/

    allChats.addAll(allOldChats);
  }

  ChatController({required this.senderId}) {
    initChat(senderId);
  }

  void addChat(ChatMessage message) async {
    /*final constantsService = ConstantsService();
    await constantsService.initConstants();
    final privateKey = constantsService.privateKey;

    String decrypt = Encryption.decryptMessage(
        encodedMessage: message.content!, privateKey: privateKey);
    message.content = decrypt;*/

    allChats.add(message);
    // allChats.add(message);
    //await ChatMessageHelper.addMessage(message);
    //allChats.clear();
    /*if (allChats.isNotEmpty) {
      allChats.removeRange(0, allChats.length);
    }*/
    //initChat(senderId);
  }
}
