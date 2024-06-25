import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phone_auth/controllers/constants/constant_service.dart';
import 'package:phone_auth/controllers/get_controllers/discussion_controller.dart';
import 'package:phone_auth/controllers/get_controllers/keys_controller.dart';
import 'package:phone_auth/controllers/get_controllers/stomp_controller.dart';
import 'package:phone_auth/const.dart';
import 'package:phone_auth/models/chat_model.dart';
//import 'package:phone_auth/screens/contact_page.dart';
import 'package:phone_auth/screens/contact_screen.dart';
import 'package:phone_auth/screens/message_screen.dart';
import 'package:phone_auth/screens/settings/settings_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //final phone = GetStorage().read('phone');
  // final String webSocketUrl = 'http://$ip:8080/ws';
  //late StompClient _stompClient;
  late DiscussionController controller;
  late KeyController? keys; // = Get.find<KeyController>();
  // String _privateKey = "";
  final constantsService = ConstantsService();
  //bool _isLoading = true;

  /*final List<Discussion> _alldiscussions = [
    Discussion(
      senderId: "+212658809729",
      lastMessage: ChatMessage(
          senderId: "+212658809729",
          content: "Hello",
          recipientId: "+212658809777"),
    ),
    Discussion(
        senderId: "+212658809729",
        lastMessage: ChatMessage(
            senderId: "+212658809729",
            content: "Hello",
            recipientId: "+212658809777")),
    Discussion(
      senderId: "+212658809729",
      lastMessage: ChatMessage(
          senderId: "+212658809729",
          content: "Hello",
          recipientId: "+212658809777"),
    ),
    Discussion(
        senderId: "+212658809729",
        lastMessage: ChatMessage(
            senderId: "+212658809729",
            content: "Hello",
            recipientId: "+212658809777")),
    Discussion(
      senderId: "+212658809729",
      lastMessage: ChatMessage(
          senderId: "+212658809729",
          content: "Hello",
          recipientId: "+212658809777"),
    ),
    Discussion(
        senderId: "+212658809729",
        lastMessage: ChatMessage(
            senderId: "+212658809729",
            content: "Hello",
            recipientId: "+212658809777")),
    Discussion(
      senderId: "+212658809729",
      lastMessage: ChatMessage(
          senderId: "+212658809729",
          content: "Hello",
          recipientId: "+212658809777"),
    ),
    Discussion(
        senderId: "+212658809729",
        lastMessage: ChatMessage(
            senderId: "+212658809729",
            content: "Hello",
            recipientId: "+212658809777"))
  ];
*/
  @override
  void initState() {
    super.initState();
    if (!loaded) {
      Get.put(DiscussionController());
      Get.put(KeyController());
      Get.put(StompController());
    }
    Get.find<StompController>();
    keys = Get.find<KeyController>();
    controller = Get.find<DiscussionController>();

    // _loadPrivateKey();
    /*  _stompClient = StompClient(
      config: StompConfig.sockJS(
        //url: 'ws://192.168.1.17:8080/stomp-endpoint',
        url: webSocketUrl,
        onConnect: onConnect,
        beforeConnect: () async {
          //  print('waiting to connect...');
          await Future.delayed(const Duration(milliseconds: 10));
          //  print('connecting...');
        },

        onWebSocketError: (dynamic error) => {}, //print(error.toString()),
        stompConnectHeaders: {'Authorization': ''},
        webSocketConnectHeaders: {'Authorization': ''},
      ),
    );*/

    //if (keys == null)
    // keys ??= Get.put(KeyController());
    //keys = Get.put(KeyController());
    // _loadContact();

    //_alldiscussions = DiscussionController();
    // _alldiscussions = DiscussionHelper.getAllDiscussion();
    //_allContact =  UserContact.fetchContacts();
    //_stompClient.activate();
  }

  /* Future<void> _loadContact() async {
    try {
      final allcontact = await UserContact.fetchContacts();
      setState(() {
        _allContact = allcontact;
      });
    } catch (e) {
      // print("An error occurs");
    }
  }*/

  /*Future<void> _loadPrivateKey() async {
    /*  AndroidOptions getAndroidOptions() => const AndroidOptions(
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

  /* void onConnect(StompFrame frame) {
    _stompClient.subscribe(
      destination: '/topic/$phone/queue/messages',
      headers: {},
      callback: (frame) async {
        // print(
        //   "+++++++++++++++++++MESSAGE RECEIVED HOME SCREEEEEEEEEEEEEEN+++++++++++++++++++");
        Map<String, dynamic>? result = json.decode(frame.body!);

        result!['content'] = Encryption.decryptMessage(
            encodedMessage: result['content'],
            privateKey: keys!.privateKey.value);
        print("Result:$result\n");
        ChatMessage message = ChatMessage.fromJson(result);
        await ChatMessageHelper.addMessage(message);
        Discussion discussion = Discussion(
            senderId: result['senderId'], lastMessage: message, unread: 1);
        await DiscussionHelper.addDiscussion(discussion);
        controller.addDiscussion(discussion);
        // Get.find<DiscussionController>().addDiscussion(discussion);
        //_alldiscussions.addDiscussion(discussion);
      },
    );
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Get.to(() => const Settings());
            },
            icon: const Icon(Icons.menu),
          ),
          title: const Text('Discussions'),
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.search))
          ],
        ),
        floatingActionButton: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
          onPressed: () {
            Get.to(() => (const ContactPage()));
            //Get.to(() => const ContactScreen());
          },
          child: const Icon(
            Icons.message,
          ),
        ),
        body: SingleChildScrollView(
          child: Obx(() {
            final dicoKeys = controller.allDiscussions.keys.toList();
            return ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                physics: const ScrollPhysics(),
                itemCount: controller.allDiscussions.length,
                itemBuilder: (context, index) {
                  final String display =
                      controller.allDiscussions[dicoKeys[index]]!.displayName;
                  ChatMessage lastMessage = controller
                      .allDiscussions[dicoKeys[index]]!.messages[controller
                          .allDiscussions[dicoKeys[index]]!.messages.length -
                      1];

                  return InkWell(
                      onTap: () async {
                        // _stompClient.deactivate();
                        //keys.dispose();
                        //Get.delete<KeyController>();
                        // controller.dispose();
                        // await myfunction();
                        //StompUnsubscribe;
                        //controller.allDiscussions.close();
                        /*Get.find<DiscussionController>().addDiscussion(Discussion(
                          senderId: controller.allDiscussions[index].senderId,
                          lastMessage:
                              controller.allDiscussions[index].lastMessage,
                          unread: 0));*/
                        // print(controller.allDiscussions.length);
                        // int i = 0;
                        // for (Discussion d in controller.allDiscussions) {
                        //   print("ID $i: ${d.discussionId}");
                        //   i++;
                        // }
                        // DiscussionHelper.reinitUnread(controller
                        //     .allDiscussions[dicoKeys[index]]!.discussionId);
                        /*addDiscussion(Discussion(
                          senderId: controller.allDiscussions[index].senderId,
                          lastMessage:
                              controller.allDiscussions[index].lastMessage,
                          unread: 0));*/
                        /* controller.addDiscussion(Discussion(
                          senderId: controller.allDiscussions[index].senderId,
                          lastMessage:
                              controller.allDiscussions[index].lastMessage,
                          unread: 0));*/
                        // controller.allDiscussions.close();
                        //Get.delete<DiscussionController>();
                        controller.reinitUnreadController(controller
                            .allDiscussions[dicoKeys[index]]!.discussionId);
                        Get.to(() => Message(
                            id: controller
                                .allDiscussions[dicoKeys[index]]!.discussionId,
                            displayname: display));
                      },
                      splashColor: Colors.greenAccent,
                      child: Container(
                        padding:
                            const EdgeInsets.only(left: 15, right: 10, top: 15),
                        child: Row(
                          children: [
                            Container(
                              width: 45,
                              height: 45,
                              margin: const EdgeInsets.only(right: 23),
                              decoration: const BoxDecoration(
                                color: Color.fromARGB(255, 18, 135, 78),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.person),
                            ),
                            Expanded(
                                child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          display,
                                          style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.grey),
                                        ),
                                        Wrap(
                                          children: [
                                            Text(
                                              lastMessage.content,
                                              style: const TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.grey),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Text(lastMessage.sentAt!.day ==
                                                DateTime.now().day
                                            ? "${lastMessage.sentAt!.hour.toString()}:${lastMessage.sentAt!.minute.toString()}"
                                            : "${lastMessage.sentAt!.day.toString()}/${lastMessage.sentAt!.month.toString()}/${lastMessage.sentAt!.year.toString()}"),
                                        controller
                                                    .allDiscussions[
                                                        dicoKeys[index]]!
                                                    .unread !=
                                                0
                                            ? Container(
                                                padding:
                                                    const EdgeInsets.all(5),
                                                decoration: const BoxDecoration(
                                                    color: Colors.green,
                                                    shape: BoxShape.circle),
                                                child: Text(controller
                                                    .allDiscussions[
                                                        dicoKeys[index]]!
                                                    .unread
                                                    .toString()),
                                              )
                                            : Container(),
                                      ],
                                    )
                                  ],
                                ),
                                /*const SizedBox(
                              height: 20,
                            ),
                            Container(
                              color: Colors.grey,
                              height: 0.5,
                            )*/
                              ],
                            ))
                          ],
                        ),
                      ));
                });
          }),
        ));
  }

  @override
  void dispose() {
    //controller.dispose();

    // _stompClient.deactivate();
    super.dispose();
  }
}

/*
SingleChildScrollView(
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          physics: const ScrollPhysics(),
          itemCount: _alldiscussions.length,
          itemBuilder: (context, index) {
            final String display = UserContact.getDisplayname(
              _allContact,
              _alldiscussions[index].senderId,
            );
            return Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Get.to(() => Message(
                        id: _alldiscussions[index].senderId,
                        displayname: display));
                  },
                  child: monWidget(context, index, display),
                )
              ],
            );
          },
        ),
      ),
    );
  }

  Widget monWidget(context, int index, String displayname) {
    return Container(
      padding: const EdgeInsets.all(5),
      margin: const EdgeInsets.all(5),
      child: Row(
        children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Icon(Icons.person_2_sharp),
            Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Text(displayname),
              Container(
                width: MediaQuery.of(context).size.width * 0.7,
                color: Colors.blueAccent,
                child: Center(
                  child: Text(
                    '${_alldiscussions[index].lastMessage.content}',
                    style: const TextStyle(fontSize: 22),
                  ),
                ),
              ),
            ]),
          ]),
          const SizedBox(
            width: 15,
          ),
        ],
      ),
    );
 */



