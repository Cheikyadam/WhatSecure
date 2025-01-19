import 'dart:convert';
import 'package:get/get.dart';
import 'package:phone_auth/controllers/get_controllers/discussion_controller.dart';
import 'package:phone_auth/controllers/get_controllers/keys_controller.dart';
import 'package:phone_auth/encryption/aes_encryption.dart';
import 'package:phone_auth/encryption/rsa_encryption.dart';
import 'package:phone_auth/models/chat_model.dart';
import 'package:phone_auth/models/message_type.dart';
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
        onWebSocketError: (dynamic error) {
          // print('Web Socket Error: $error');
        },
        onUnhandledFrame: (frame) {
          //print('Unhandled frame: $frame');
        },
        onUnhandledMessage: (message) {
          //print('Unhandled message: $message');
        },
        onUnhandledReceipt: (frame) {
          //print('unhandled receipt: $frame');
        },
        onStompError: (error) {
          // print(('Stomp error: $error'));
        },
        onDebugMessage: (message) {
          print('onDebugMessage: $message');
        },
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
        ChatMessage message = ChatMessage.fromJson(result!);
        if (message.messageType == MessageType.text) {
          message.content = Encryption.decryptMessage(
              encodedMessage: message.content, //result['content'],
              privateKey: keys.privateKey.value);
        } else {
          //decrypt file
          final key = Encryption.decryptMessage(
              encodedMessage: message.fileInfos['key'],
              privateKey: keys.privateKey.value);
          final iv = Encryption.decryptMessage(
              encodedMessage: message.fileInfos['iv'],
              privateKey: keys.privateKey.value);
          message.content = AesEncryption.decryptFile(message.content, key, iv);
          message.fileInfos['key'] = "";
          message.fileInfos['iv'] = "";
        }
        //print(keys.privateKey);

        controller.addMessageToDiscussionController(message, message.senderId);
      },
    );
  }
}
