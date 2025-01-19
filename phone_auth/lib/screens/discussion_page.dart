import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phone_auth/const.dart';
import 'package:phone_auth/controllers/constants/constant_service.dart';
import 'package:phone_auth/controllers/get_controllers/discussion_controller.dart';
import 'package:phone_auth/controllers/get_controllers/keys_controller.dart';
import 'package:phone_auth/controllers/get_controllers/settings_controller.dart';
import 'package:phone_auth/controllers/get_controllers/stomp_controller.dart';
import 'package:phone_auth/controllers/hive_controller/hive_helper.dart';
import 'package:phone_auth/models/chat_model.dart';
import 'package:phone_auth/models/message_type.dart';
import 'package:phone_auth/screens/contact_page.dart';
import 'package:phone_auth/screens/message_page.dart';
import 'package:intl/intl.dart';

// class DiscussionPage extends StatefulWidget {
//   const DiscussionPage({super.key});

//   @override
//   State<DiscussionPage> createState() => _DiscussionPageState();
// }

// class _DiscussionPageState extends State<DiscussionPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Column(
//           children: [
//             const Center(
//               child: Text(
//                 'Chats',
//                 style: TextStyle(fontSize: 45, fontWeight: FontWeight.bold),
//               ),
//             ),
//             Container(
//               height: 35,
//               margin: const EdgeInsets.only(left: 12, right: 12, top: 12),
//               decoration: BoxDecoration(
//                   color: const Color.fromARGB(255, 210, 210, 210),
//                   border: Border.all(),
//                   borderRadius: const BorderRadius.all(Radius.circular(12))),
//               child: Row(
//                 children: [
//                   Container(
//                     margin: const EdgeInsets.only(
//                         left: 25, top: 2, right: 50, bottom: 3),
//                     child: Image.asset(
//                       'assets/icons/search.png',
//                       height: 20,
//                     ),
//                   ),
//                   const Expanded(
//                     child: TextField(
//                       decoration: InputDecoration(
//                           hintText: 'Rechercher dans les chats',
//                           border: InputBorder.none),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 15),
//             Container(
//               margin: const EdgeInsets.only(left: 12, right: 12),
//               child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     FirstSectionWidget(
//                       color: color2,
//                       text: 'Toutes',
//                       onTap: () {},
//                     ),
//                     FirstSectionWidget(
//                       color: color1,
//                       text: 'Story',
//                       onTap: () {},
//                     ),
//                     FirstSectionWidget(
//                       color: color1,
//                       text: 'Non lus',
//                       onTap: () {},
//                     ),
//                   ]),
//             ),
//             Container(
//               margin: const EdgeInsets.only(top: 15),
//               width: MediaQuery.of(context).size.width,
//               decoration: const BoxDecoration(
//                 color: color1,
//                 border: Border(bottom: BorderSide(color: color1)),
//               ),
//             ),
//             Expanded(
//               child: ListView.builder(
//                   shrinkWrap: true,
//                   itemCount: 9,
//                   itemBuilder: (context, index) => const DiscussionWidget()),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class DiscussionWidget extends StatelessWidget {
//   const DiscussionWidget({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: () => Get.to(() => const MessagesPage()),
//       child: Container(
//         margin: const EdgeInsets.only(left: 8.0, top: 4.0),
//         padding: const EdgeInsets.only(
//           left: 8.0,
//           top: 8.0,
//         ),
//         child: Row(
//           children: [
//             const SizedBox(
//               width: 15,
//             ),
//             Container(
//               width: 50,
//               height: 50,
//               margin: const EdgeInsets.only(right: 15),
//               padding: const EdgeInsets.all(7),
//               decoration: const BoxDecoration(
//                 color: color1,
//                 shape: BoxShape.circle,
//               ),
//               child: Image.asset(
//                 'assets/icons/profil.png',
//                 fit: BoxFit.contain,
//               ),
//             ),
//             Expanded(
//               child: Column(
//                 children: [
//                   Container(
//                     margin: const EdgeInsets.only(right: 10),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         const Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               'Adam',
//                               style: TextStyle(
//                                   fontSize: 20, fontWeight: FontWeight.bold),
//                             ),
//                             Text(
//                               'Bonjour, tu vas bien?',
//                             ),
//                           ],
//                         ),
//                         Column(
//                           children: [
//                             Container(
//                               padding: const EdgeInsets.all(5),
//                               decoration: const BoxDecoration(
//                                   color: color2, shape: BoxShape.circle),
//                               child: const Text('2'),
//                             ),
//                             const Text('19h23')
//                           ],
//                         )
//                       ],
//                     ),
//                   ),
//                   Container(
//                     padding: const EdgeInsets.only(bottom: 15.0),
//                     decoration: const BoxDecoration(
//                         border: Border(bottom: BorderSide(color: color1))),
//                   )
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class FirstSectionWidget extends StatelessWidget {
//   final String text;
//   final VoidCallback onTap;
//   final Color color;
//   const FirstSectionWidget(
//       {super.key,
//       required this.text,
//       required this.color,
//       required this.onTap});

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.all(2),
//         margin: const EdgeInsets.only(bottom: 12),
//         decoration: BoxDecoration(
//             color: color,
//             borderRadius: const BorderRadius.all(Radius.circular(7))),
//         child: Text(text, style: Theme.of(context).textTheme.bodyMedium),
//       ),
//     );
//   }
// }

class DiscussionPage extends StatefulWidget {
  const DiscussionPage({super.key});

  @override
  State<DiscussionPage> createState() => _DiscussionPageState();
}

class _DiscussionPageState extends State<DiscussionPage> {
  late DiscussionController controller;
  late KeyController? keys;
  final constantsService = ConstantsService();

  @override
  void initState() {
    super.initState();
    if (!loaded) {
      Get.put(StompController());
      Get.put(DiscussionController());
      Get.put(KeyController());
    }

    Get.find<StompController>();
    keys = Get.find<KeyController>();
    controller = Get.find<DiscussionController>();
  }

  @override
  Widget build(BuildContext context) {
    DiscussionHelper.initAllDiscussion();
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Center(
              child: Text(
                'Chats',
                style: TextStyle(fontSize: 45, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              height: 35,
              margin: const EdgeInsets.only(left: 12, right: 12, top: 12),
              decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 210, 210, 210),
                  border: Border.all(),
                  borderRadius: const BorderRadius.all(Radius.circular(12))),
              child: Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(
                        left: 25, top: 2, right: 50, bottom: 3),
                    child: Image.asset(
                      'assets/icons/search.png',
                      height: 20,
                    ),
                  ),
                  const Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                          hintText: 'Rechercher dans les chats',
                          border: InputBorder.none),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            Container(
              margin: const EdgeInsets.only(left: 12, right: 12),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Obx(
                      () => FirstSectionWidget(
                        color: keys!.inUnread.isFalse ? color2 : color1,
                        text: 'Toutes',
                        onTap: () {
                          if (keys!.inUnread.value == true) {
                            keys!.changeInUnread();
                          }
                        },
                      ),
                    ),
                    // FirstSectionWidget(
                    //   color: color1,
                    //   text: 'Story',
                    //   onTap: () {},
                    // ),
                    Obx(
                      () => FirstSectionWidget(
                        color: keys!.inUnread.isTrue ? color2 : color1,
                        text: 'Non lus',
                        onTap: () {
                          if (keys!.inUnread.isFalse) {
                            keys!.changeInUnread();
                          }
                        },
                      ),
                    ),
                  ]),
            ),
            Container(
              margin: const EdgeInsets.only(top: 15),
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                color: color1,
                border: Border(bottom: BorderSide(color: color1)),
              ),
            ),
            Expanded(
              child: Obx(() {
                final dicoKeys = keys!.inUnread.value
                    ? controller.allDiscussionsUnread.keys.toList()
                    : controller.allDiscussions.keys.toList();
                final currentDiscussions = keys!.inUnread.value
                    ? controller.allDiscussionsUnread
                    : controller.allDiscussions;
                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: currentDiscussions.length,
                    itemBuilder: (context, index) {
                      if (dicoKeys.isEmpty) {
                        return Container();
                      } else {
                        final String display =
                            currentDiscussions[dicoKeys[index]]!.displayName;
                        ChatMessage? lastMessage = // controller
                            currentDiscussions[dicoKeys[index]]!
                                    .messages
                                    .isNotEmpty
                                ? currentDiscussions[dicoKeys[index]]!.messages[
                                    currentDiscussions[dicoKeys[index]]!
                                            .messages
                                            .length -
                                        1]
                                : null;
                        final discussionId = //controller
                            currentDiscussions[dicoKeys[index]]!.discussionId;
                        final int unread =
                            currentDiscussions[dicoKeys[index]]!.unread;
                        return DiscussionWidget(
                          displayName: display,
                          lastMessage: lastMessage,
                          unread: unread,
                          discussionId: discussionId,
                        );
                      }
                    });
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class DiscussionWidget extends StatelessWidget {
  final String displayName;
  final ChatMessage? lastMessage;
  final int unread;
  final String discussionId;
  const DiscussionWidget({
    super.key,
    required this.displayName,
    required this.lastMessage,
    required this.discussionId,
    required this.unread,
  });

  @override
  Widget build(BuildContext context) {
    if (lastMessage == null) {
      return Container();
    }
    return InkWell(
      onTap: () {
        Get.find<DiscussionController>().reinitUnreadController(discussionId);
        Get.to(() => MessagesPage(
              displayName: displayName,
              id: discussionId,
            ));
      },
      child: Container(
        margin: const EdgeInsets.only(left: 8.0, top: 2.0),
        padding: const EdgeInsets.only(
          left: 8.0,
          top: 8.0,
        ),
        child: Row(
          children: [
            const SizedBox(
              width: 15,
            ),
            Container(
              margin: const EdgeInsets.only(right: 15),
              child: IconProfilWidgetContact(
                id: discussionId,
                settingsController: Get.find<SettingsController>(),
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              displayName,
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            lastMessage!.messageType == MessageType.text
                                ? Text(
                                    lastMessage!.content.length > 20
                                        ? "${lastMessage!.content.substring(0, 25)}..."
                                        : lastMessage!.content,
                                  )
                                : Row(
                                    children: [
                                      lastMessage!.messageType ==
                                              MessageType.image
                                          ? Image.asset(
                                              'assets/icons/picture.png',
                                              height: 35,
                                              width: 35,
                                            )
                                          : IconToLoadWidget(
                                              icons: lastMessage!
                                                  .fileInfos['fileName']
                                                  .split('.')
                                                  .last),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        lastMessage!.fileInfos['fileName']
                                                    .length <
                                                18
                                            ? lastMessage!.fileInfos['fileName']
                                            : '${lastMessage!.fileInfos['fileName'].split('.').first.substring(0, 14)}....${lastMessage!.fileInfos['fileName'].split('.').last}',
                                      ),
                                    ],
                                  ),
                          ],
                        ),
                        Column(
                          children: [
                            unread == 0
                                ? Container()
                                : Container(
                                    padding: const EdgeInsets.all(5),
                                    decoration: const BoxDecoration(
                                        color: color2, shape: BoxShape.circle),
                                    child: Text(unread.toString()),
                                  ),
                            Text(lastMessage!.sentAt!.day == DateTime.now().day
                                ? DateFormat('HH:mm')
                                    .format(lastMessage!.sentAt!)
                                : DateFormat('dd/MM/yyyy')
                                    .format(lastMessage!.sentAt!))
                          ],
                        )
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    decoration: const BoxDecoration(
                        border: Border(bottom: BorderSide(color: color1))),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FirstSectionWidget extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final Color color;
  const FirstSectionWidget(
      {super.key,
      required this.text,
      required this.color,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(2),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.all(Radius.circular(7))),
        child: Center(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium,
            strutStyle: StrutStyle.fromTextStyle(
                const TextStyle(fontWeight: FontWeight.bold)),
          ),
        ),
      ),
    );
  }
}
