import 'dart:convert';
import 'package:get/get.dart';
import 'package:phone_auth/controllers/get_controllers/discussion_controller.dart';
import 'package:phone_auth/controllers/get_controllers/keys_controller.dart';
import 'package:phone_auth/encryption/encryption.dart';
import 'package:phone_auth/models/chat_model.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:phone_auth/const.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

class StompController extends GetxController {
  late StompClient stompClient;
  @override
  void onInit() {
    super.onInit();
    _connectToServer();
    stompClient.activate();
  }

  _connectToServer() {
    stompClient = StompClient(
      config: StompConfig.sockJS(
        url: webSocketUrl,
        onConnect: onConnect,
        beforeConnect: () async {},
        onWebSocketError: (dynamic error) => {},
        stompConnectHeaders: {'Authorization': ''},
        webSocketConnectHeaders: {'Authorization': ''},
      ),
    );
  }

  void onConnect(StompFrame frame) {
    final KeyController keys = Get.find<KeyController>();
    final DiscussionController controller = Get.find<DiscussionController>();
    final phone = keys.phone.value;
    stompClient.subscribe(
      destination: '/topic/$phone/queue/messages',
      headers: {},
      callback: (frame) async {
        Map<String, dynamic>? result = json.decode(frame.body!);
        print('received');
        result!['content'] = Encryption.decryptMessage(
            encodedMessage: result['content'],
            privateKey: keys.privateKey.value);
        // print(keys.privateKey);
        ChatMessage message = ChatMessage.fromJson(result);
        controller.addMessageToDiscussionController(message, message.senderId);
      },
    );
  }
}
