import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:phone_auth/controllers/constants/constant_service.dart';
import 'package:phone_auth/controllers/get_controllers/chat_controller.dart';
import 'package:phone_auth/controllers/get_controllers/keys_controller.dart';
//import 'package:phone_auth/controllers/get_controllers/discussion_controller.dart';
import 'package:phone_auth/controllers/hive_controller/hive_helper.dart';
import 'package:phone_auth/encryption/encryption.dart';
//import 'package:phone_auth/controllers/hive_controller/hive_helper.dart';
import 'package:phone_auth/models/chat_model.dart';
import 'package:phone_auth/models/discussions_model.dart';
import 'package:phone_auth/models/user_contact.dart';
import 'package:phone_auth/screens/home.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';
import 'package:stomp_dart_client/stomp_handler.dart';

class Message extends StatefulWidget {
  const Message({super.key, required this.id, required this.displayname});
  final String id;
  final String displayname;

  @override
  State<Message> createState() => _MessageState();
}

class _MessageState extends State<Message> {
  final phone = GetStorage().read('phone');
  final String webSocketUrl = 'http://100.100.56.13:8080/ws';
  late StompClient _stompClient;
  final TextEditingController _controller = TextEditingController();
  late ChatController _allMessages;
  //late KeyController keys;
  KeyController? keys = Get.find<KeyController>();
  // String _privateKey = "";
  // bool _isLoading = true;
  final constantsService = ConstantsService();

  // late DiscussionController discussionController;

  /*final List<ChatMessage> _allMessages = [
    ChatMessage(
        senderId: "2222", content: "Coucou Adam", recipientId: "22222222222"),
    ChatMessage(
        senderId: "24332",
        content: "Coucou, comment vas tu",
        recipientId: "222222222"),
    ChatMessage(
        senderId: "24332",
        content: "Coucou, je vais tres bien ",
        recipientId: "222222222"),
    ChatMessage(
        senderId: "2222",
        content: "Coool i am so happy for you today! test micro",
        recipientId: "22222222222"),
    ChatMessage(
        senderId: "2222",
        content:
            "Coool i am so happy for you today! test micro Coool i am so happy for you today! test micro Coool i am so happy for you today! test micro Coool i am so happy for you today! test micro Coool i am so happy for you today! test micro",
        recipientId: "22222222222"),
  ];*/

  @override
  void initState() {
    super.initState();
    //_loadPrivateKey();
    _stompClient = StompClient(
      config: StompConfig.sockJS(
        //url: 'ws://192.168.1.17:8080/stomp-endpoint',
        url: webSocketUrl,
        onConnect: onConnect,
        beforeConnect: () async {
          //print('waiting to connect...');
          // _allMessages = Get.put(ChatController(senderId: widget.id));
          await Future.delayed(const Duration(milliseconds: 10));
          // print('connecting...');
        },

        onWebSocketError: (dynamic error) => {}, //print(error.toString()),
        stompConnectHeaders: {'Authorization': ''},
        webSocketConnectHeaders: {'Authorization': ''},
        onDebugMessage: (frame) {
          //print('WebSocket - onDebugMessage executed! - $frame');
        },
        onStompError: (StompFrame frame) {
          //print(
          //  'A stomp error occurred in web socket connection :: ${frame.toString()}');
        },

        onWebSocketDone: () {
          //print('WebSocket - onWebSocketDone executed!');
        },
        onDisconnect: (frame) {
          // print('WebSocket - onDisconnect executed! ${frame.toString()}');
        },
        onUnhandledFrame: (frame) {
          // print('WebSocket - onUnhandledFrame executed! ${frame.toString()}');
        },
        onUnhandledMessage: (frame) {
          // print('WebSocket - onUnhandledMessage executed! ${frame.toString()}');
        },
        onUnhandledReceipt: (frame) {
          //print('WebSocket - onUnhandledReceipt executed! ${frame.toString()}');
        },
      ),
    );
    //print("+++++++++++${widget.id}+++++++++++++++++++++++");
    //_allMessages = Get.
    //discussionController = Get.put(DiscussionController());
    keys ??= Get.put(KeyController());
    //keys = Get.put(KeyController());
    _allMessages = Get.put(ChatController(senderId: widget.id));

    // _allMessages =  ChatMessageHelper.getMessageBySenderId(widget.id);

    _stompClient.activate();
  }

  void onConnect(StompFrame frame) {
    //print("Connected");
    _stompClient.subscribe(
      destination: '/topic/$phone/queue/messages',
      headers: {},
      callback: (frame) async {
        Map<String, dynamic>? result = json.decode(frame.body!);
        //print(
        //  "+++++++++++++++++++++++++MESSSAGE SCREENNNNNN+++++++++++++++++++");
        //print(
        // "==============================$result================================");
        ChatMessage message = ChatMessage.fromJson(result!);

        await ChatMessageHelper.addMessage(message);
        Discussion discussion = Discussion(
            senderId: result['senderId'], lastMessage: message, unread: 0);
        // Get.find<DiscussionController>().addDiscussion(discussion);
        DiscussionHelper.addDiscussion(discussion);
        // _allMessages.addChat(message);
        //Get.find<ChatController>().addChat(message);
        // print("+++++++++++++++++++++++++++++++++++++++++++++++++++++++");
        _allMessages.addChat(message);

        // print(frame.body);
      },
    );
  }

  void _send(ChatMessage message) async {
    AppContact contact = await AppContactHelper.getContact(userId: widget.id);

    String content = message.content!;
    String cryptedMes = Encryption.encryptMessage(
        message: content, publicKey: contact.publicKey);

    //print("PUBLIC KEY RECIPIENT:  ${contact.publicKey}");

    message.content = cryptedMes;

    _stompClient.send(
      destination: "/app/chat",
      body: json.encode(message.toMap()),
    );

    //  print("************************$content**********************");

    //print("PUBLIC KEY SENDER:  $ publicKey");
    String newEn = Encryption.encryptMessage(
        message: content, publicKey: Get.find<KeyController>().publicKey.value);

    message.content = newEn;

    await ChatMessageHelper.addMessage(message);
    Discussion discussion = Discussion(
        senderId: message.recipientId!, lastMessage: message, unread: 0);
    //Get.find<DiscussionController>().addDiscussion(discussion);
    await DiscussionHelper.addDiscussion(discussion);

    _allMessages.addChat(message);

    //_allMessages.addChat(message);
    //Get.find<ChatController>().addChat(message);

    _controller.clear();
  }

  /* Future<void> _loadPrivateKey() async {
    /*AndroidOptions getAndroidOptions() => const AndroidOptions(
          encryptedSharedPreferences: true,
        );
    final storage = FlutterSecureStorage(aOptions: getAndroidOptions());
    final privateKey = await storage.read(key: 'privateKey');
    setState(() {
      _privateKey = privateKey!;
    });*/
    await constantsService.initConstants();
    setState(() {
      _isLoading = false;
    });
  }*/

  @override
  Widget build(BuildContext context) {
    //print("++++++++++++++++++++++++++++++++++++++++");
    //_allMessages = Get.put(ChatController(senderId: widget.id));
    return Scaffold(
      backgroundColor: const Color(0xFF34322f),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            _stompClient.deactivate();
            _allMessages.dispose();
            //keys.dispose();
            //Get.delete<KeyController>();
            // _allMessages.allChats.close();
            Get.delete<ChatController>();
            // Get.delete<DiscussionController>();
            //Get.close<ChatController>(0);
            StompUnsubscribe;
            Get.off(() => const HomePage());
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: Text(widget.displayname),
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.more_vert,
                //size: 23,
                //color: Colors.white,
              )),
        ],
      ),
      body: /*_isLoading ? Container() :*/ chatSection(),
      /* Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          myWidget(_allMessages),
          const SizedBox(
            height: 15,
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: MediaQuery.sizeOf(context).width * 0.85,
                child: Form(
                  child: TextFormField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      labelText: 'Send a message',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                    ),
                  ),
                ),
              ),
              IconButton(
                  onPressed: () {
                    if (_controller.text.isNotEmpty) {
                      send(ChatMessage(
                        senderId: phone,
                        content: _controller.text,
                        recipientId: widget.id,
                      ));
                      _controller.clear();
                    }
                  },
                  icon: const Icon(Icons.send))
            ],
          ),
          const SizedBox(
            height: 10,
          )
        ],
      ),
     
    );
  }

  Widget myWidget(List<ChatMessage> chat) {
    String messages = "";
    for (int i = 0; i < chat.length; i++) {
      messages += "${chat[i].senderId!}: ${chat[i].content!} \n";
    }
    return Text(messages);
  }
*/
      bottomNavigationBar: bottomSection(),
    );
  }

  Widget bottomSection() {
    return BottomAppBar(
      elevation: 10.0,
      child: Container(
        decoration: const BoxDecoration(
            border: Border.fromBorderSide(BorderSide.none),
            color: Color(0xFF34322f)),
        padding:
            const EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 10),
        margin: const EdgeInsets.all(0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                height: 43,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(221, 21, 19, 19),
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    /*SizedBox(width: 10.0),
                    Icon(
                      Icons.insert_emoticon,
                      size: 25.0,
                      color: Colors.white,
                    )*/
                    const SizedBox(
                      width: 15.0,
                    ),
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Message',
                        ),
                      ),
                    ),
                    /*Icon(
                      Icons.upload_outlined,
                      size: 25.0,
                      color: Colors.white,
                    )
                    SizedBox(
                      width: 8.0,
                    ),*/
                    /*Icon(
                      Icons.image,
                      size: 25.0,
                      color: Colors.white,
                    )
                    SizedBox(
                      width: 10.0,
                    ),*/
                  ],
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(
                left: 25,
              ),
              width: 45,
              height: 45,
              decoration: const BoxDecoration(
                color: Color.fromARGB(221, 21, 19, 19),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: () {
                  if (_controller.text.isNotEmpty) {
                    _send(ChatMessage(
                      senderId: phone,
                      content: _controller.text,
                      recipientId: widget.id,
                    ));
                    //_controller.clear();
                  }
                },
                icon: const Icon(
                  Icons.send,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget chatSection() {
    return Container(
      height: double.infinity,
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(40), topLeft: Radius.circular(40))),
      child: SingleChildScrollView(
        reverse: true,
        scrollDirection: Axis.vertical,
        padding: const EdgeInsets.all(7),
        child: Obx(
          () => ListView.builder(
            physics: const ScrollPhysics(),
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: _allMessages.allChats.length,
            itemBuilder: (context, index) {
              //print(keys.privateKey.value);
              //print(_allMessages.allChats[index].content!);
              String decrypt = Encryption.decryptMessage(
                  encodedMessage: _allMessages.allChats[index].content!,
                  privateKey: keys!.privateKey.value);
              //print(decrypt);
              //print(_allMessages.allChats[index].senderId);
              return Column(
                crossAxisAlignment:
                    _allMessages.allChats[index].senderId == phone
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    constraints: BoxConstraints(
                      maxWidth:
                          _allMessages.allChats[index].content!.length > 21
                              ? MediaQuery.of(context).size.width * 0.6
                              : MediaQuery.of(context).size.width * 0.4,
                      //minWidth: 10,
                      //minHeight: 2
                    ),
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                        color: _allMessages.allChats[index].senderId! == phone
                            ? Colors.green
                            : Colors.black38,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(children: [
                          Expanded(
                            child: Text(
                              decrypt,
                              style: const TextStyle(fontSize: 15),
                            ),
                          ),
                        ]),
                        Text(
                            "${_allMessages.allChats[index].sentAt!.hour}:${_allMessages.allChats[index].sentAt!.minute}"),
                      ],
                    ),
                  ),
                  //  ]),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _stompClient.deactivate();
    // _allMessages.dispose();
    //_controller.dispose();
    super.dispose();
  }
}
/*
class Chat extends StatefulWidget {
  final String chatId;
  final String userId;
  const Chat({super.key, required this.chatId, required this.userId});

  @override
  ChatState createState() => ChatState();
}

class ChatState extends State<Chat> {
  final phone = GetStorage().read('phone');
  final String webSocketUrl = 'http://192.168.3.2:8080/ws';
  late StompClient _client;
  final TextEditingController _controller = TextEditingController();
  List<dynamic> messages = List.empty();
  @override
  void initState() {
    super.initState();
    _client = StompClient(
        config: StompConfig.sockJS(
            url: webSocketUrl, onConnect: onConnectCallback));
    _client.activate();
  }

  void onConnectCallback(StompFrame connectFrame) {
    _client.subscribe(
        destination: '/topic/chat/${widget.chatId}',
        headers: {},
        callback: (frame) {
          print("FRAME BODY======${frame.body}==============\n");
          // Received a frame for this subscription
          setState(() {
            messages = jsonDecode(frame.body!).reversed.toList();
          });

          //ChatMessage.userFromJsonString(jsonDecode(frame.body!));
        });
  }

  void _sendMessage() {
    final message = ChatMessage(
        senderId: widget.chatId,
        content: _controller.text,
        recipientId: widget.chatId,
        sentAt: DateTime.now());
    if (_controller.text.isNotEmpty) {
      _client.send(
        destination: '/app/chat/${widget.chatId}', // Replace with your chat ID
        body: json.encode(
          message.toMap(),
        ), // Format the message as needed
      );
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    //double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Form(
              child: TextFormField(
                controller: _controller,
                decoration: const InputDecoration(labelText: 'Send a message'),
              ),
            ),
            const SizedBox(height: 24),
            SingleChildScrollView(
              child: SizedBox(
                height: 125,
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    // Extract the item from the list
                    //ChatMessage item = messages[index];
                    Map<String, dynamic> item = messages[index];
                    // Create a Text widget for the item
                    return ListTile(
                      title: Text(item['content']),
                      // You can add more widgets here, e.g., icons, buttons, etc.
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _sendMessage,
        tooltip: 'Send message',
        child: const Icon(Icons.send),
      ),
    );
  }

  @override
  void dispose() {
    _client.deactivate();
    _controller.dispose();
    super.dispose();
  }
}*/

/*class BottomSection extends StatelessWidget {
  const BottomSection({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      elevation: 10.0,
      child: Container(
        decoration: const BoxDecoration(
            border: Border.fromBorderSide(BorderSide.none),
            color: Color(0xFF34322f)),
        padding:
            const EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 10),
        margin: const EdgeInsets.all(0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                height: 43,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(221, 21, 19, 19),
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    /*SizedBox(width: 10.0),
                    Icon(
                      Icons.insert_emoticon,
                      size: 25.0,
                      color: Colors.white,
                    )*/
                    SizedBox(
                      width: 15.0,
                    ),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Message',
                        ),
                      ),
                    ),
                    /*Icon(
                      Icons.upload_outlined,
                      size: 25.0,
                      color: Colors.white,
                    )
                    SizedBox(
                      width: 8.0,
                    ),*/
                    /*Icon(
                      Icons.image,
                      size: 25.0,
                      color: Colors.white,
                    )
                    SizedBox(
                      width: 10.0,
                    ),*/
                  ],
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(
                left: 25,
              ),
              width: 45,
              height: 45,
              decoration: const BoxDecoration(
                color: Color.fromARGB(221, 21, 19, 19),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.send,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}*/

/*class ChatingSection extends StatelessWidget {
  const ChatingSection(
      {super.key, required this.messages, required this.phone});
  final ChatController messages;
  final String phone;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(40), topLeft: Radius.circular(40))),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        padding: const EdgeInsets.all(7),
        child: GetBuilder(
          init: messages,
          builder: (controller) => ListView.builder(
            physics: const ScrollPhysics(),
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: messages.allChats.length,
            itemBuilder: (context, index) {
              return Column(
                crossAxisAlignment: messages.allChats[index].senderId == phone
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    constraints: BoxConstraints(
                      maxWidth: messages.allChats[index].content!.length > 21
                          ? MediaQuery.of(context).size.width * 0.6
                          : MediaQuery.of(context).size.width * 0.4,
                      //minWidth: 10,
                      //minHeight: 2
                    ),
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                        color: messages.allChats[index].senderId! == phone
                            ? Colors.green
                            : Colors.black38,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(children: [
                          Expanded(
                            child: Text(
                              messages.allChats[index].content!,
                              style: const TextStyle(fontSize: 15),
                            ),
                          ),
                        ]),
                        Text(
                            "${messages.allChats[index].sentAt!.hour}:${messages.allChats[index].sentAt!.minute}"),
                      ],
                    ),
                  ),
                  //  ]),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}*/
