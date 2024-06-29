import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:phone_auth/models/message_type.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:phone_auth/const.dart';
import 'package:phone_auth/controllers/get_controllers/discussion_controller.dart';
import 'package:phone_auth/controllers/get_controllers/keys_controller.dart';
import 'package:phone_auth/controllers/get_controllers/settings_controller.dart';
import 'package:phone_auth/controllers/get_controllers/stomp_controller.dart';
import 'package:phone_auth/encryption/encryption.dart';
import 'package:phone_auth/models/chat_model.dart';
import 'package:phone_auth/models/user_contact.dart';
import 'package:phone_auth/screens/contact_page.dart';
import 'package:phone_auth/screens/contact_profil_page.dart';
import 'package:phone_auth/screens/my_new_home_page.dart';
import 'package:phone_auth/screens/settings/settings_screen.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:mime/mime.dart';
import 'dart:typed_data';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:open_file/open_file.dart';

/*class MessagesPage extends StatefulWidget {
  const MessagesPage({super.key});

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  final TextEditingController _controller = TextEditingController();
  List<Message> messages = [
    Message(
        text: 'Yes sure!',
        date: DateTime.now().subtract(const Duration(minutes: 1)),
        isSentByMe: false),
    Message(
        text: 'Okay it works for me',
        date: DateTime.now().subtract(const Duration(minutes: 1)),
        isSentByMe: true),
    Message(
        text: 'See you in five fays',
        date: DateTime.now().subtract(const Duration(days: 4)),
        isSentByMe: false),
    Message(
        text: 'Okay bro',
        date: DateTime.now().subtract(const Duration(days: 4)),
        isSentByMe: true),
    Message(
        text: 'Yes sure!',
        date: DateTime.now().subtract(const Duration(days: 4)),
        isSentByMe: false),
    Message(
        text: 'Okay it works for me',
        date: DateTime.now().subtract(const Duration(minutes: 3)),
        isSentByMe: true),
    Message(
        text: 'See you in five fays',
        date: DateTime.now().subtract(const Duration(minutes: 2)),
        isSentByMe: false),
    Message(
        text: 'Okay bro',
        date: DateTime.now().subtract(const Duration(minutes: 1)),
        isSentByMe: true)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 25,
        centerTitle: false,
        backgroundColor: color1,
        title: Row(
          children: [
            Container(
              width: 45,
              height: 45,
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Image.asset(
                'assets/icons/profil.png',
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            const Text(
              'Adam',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          FaceIconWidget(
            color: const Color(0xffDBCDE5),
            onTap: () {},
          ),
          const SizedBox(
            width: 15,
          ),
          InkWell(
            onTap: () {},
            child: Image.asset(
              'assets/icons/telephone_b.png',
              width: 37,
              height: 37,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
        ],
      ),
      body: Column(children: [
        Expanded(
            child: GroupedListView<Message, DateTime>(
          padding: const EdgeInsets.all(8.0),
          reverse: true,
          order: GroupedListOrder.DESC,
          useStickyGroupSeparators: true,
          floatingHeader: true,
          elements: messages,
          groupBy: (message) =>
              DateTime(message.date.year, message.date.month, message.date.day),
          groupHeaderBuilder: (Message message) => SizedBox(
            height: 40,
            child: Center(
                child: Card(
              color: Theme.of(context).primaryColor,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  DateFormat.yMMMd().format(message.date),
                ),
              ),
            )),
          ),
          itemBuilder: (context, Message message) => Align(
            alignment: message.isSentByMe
                ? Alignment.centerRight
                : Alignment.centerLeft,
            child: MessageBubble(
              message: message,
            ),
          ),
        )),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: TextField(
                    style: const TextStyle(fontSize: 15, color: Colors.black),
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: "Ecrire votre message ici...",
                      hintStyle: TextStyle(color: Colors.black),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(12),
                    ),
                    onSubmitted: (text) {
                      _sendMessage();
                    },
                  ),
                ),
              ),
              const SizedBox(
                  width:
                      8.0), // Add some space between the TextField and the button
              Container(
                width: 45,
                height: 45,
                padding: const EdgeInsets.all(7),
                decoration: const BoxDecoration(
                  color: color1,
                  shape: BoxShape.circle,
                ),
                child: GestureDetector(
                  onTap: () {
                    _sendMessage();
                  },
                  child: Image.asset('assets/icons/send_msg.png'),
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }

  void _sendMessage() {
    final text = _controller.text;
    if (text.isEmpty) return;

    final message = Message(text: text, date: DateTime.now(), isSentByMe: true);

    setState(() {
      messages.add(message);
      _controller.clear();
    });
  }
}

class Message {
  final String text;
  final DateTime date;
  final bool isSentByMe;

  const Message(
      {required this.text, required this.date, required this.isSentByMe});
}

class MessageBubble extends StatelessWidget {
  final Message message;

  const MessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final timeString = DateFormat('HH:mm').format(message.date);

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: message.isSentByMe
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.8,
            ),
            decoration: BoxDecoration(
              color: message.isSentByMe ? color2 : color1,
              borderRadius: message.isSentByMe
                  ? const BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      bottomLeft: Radius.circular(20.0),
                      bottomRight: Radius.circular(20.0),
                    )
                  : const BorderRadius.only(
                      topRight: Radius.circular(20.0),
                      bottomLeft: Radius.circular(20.0),
                      bottomRight: Radius.circular(20.0),
                    ),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    message.text,
                    style: TextStyle(
                      color: message.isSentByMe ? Colors.white : Colors.black54,
                      fontSize: 15.0,
                    ),
                  ),
                  const SizedBox(height: 2.0),
                  Text(
                    timeString,
                    style: TextStyle(
                      color:
                          message.isSentByMe ? Colors.white70 : Colors.black45,
                      fontSize: 10.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
*/

class MessagesPage extends StatefulWidget {
  final String displayName;
  final String id;
  const MessagesPage({super.key, required this.id, required this.displayName});

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  final TextEditingController _controller = TextEditingController();
  late StompController stompController;
  late DiscussionController discussionController;
  KeyController? keys = Get.find<KeyController>();
  late ImagePicker imagePicker;

  @override
  void initState() {
    super.initState();
    stompController = Get.find<StompController>();
    discussionController = Get.find<DiscussionController>();
    keys ??= Get.put(KeyController());
    imagePicker = ImagePicker();
  }

  _imgFromCamera() async {
    XFile? pickedFile = await imagePicker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      File image = File(pickedFile.path);
      String fileName = image.path.split('/').last;
      _compressAndSend(image, fileName);
    }
  }

  _compressAndSend(File file, String fileName) async {
    File? compressedImage = await _compressImage(file);
    String base64Image = base64Encode(compressedImage!.readAsBytesSync());
    _send(ChatMessage(
        fileName: fileName,
        messageType: MessageType.image,
        senderId: keys!.phone.value,
        content: base64Image,
        recipientId: widget.id));
  }

  Future<File?> _compressImage(File image) async {
    final tempDir = await getTemporaryDirectory();
    final targetPath =
        join(tempDir.path, 'temp_${DateTime.now().millisecondsSinceEpoch}.jpg');

    final result = await FlutterImageCompress.compressAndGetFile(
      image.absolute.path,
      targetPath,
      quality: 50,
    );

    return File(result!.path);
  }

  _chooseFile() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowMultiple: true);

    if (result != null) {
      List<File> files = result.paths.map((path) => File(path!)).toList();
      for (final currentFile in files) {
        if (isImage(currentFile.path)) {
          String fileName = currentFile.path.split('/').last;
          _compressAndSend(currentFile, fileName);
        } else {
          String fileName = currentFile.path.split('/').last;
          String base64Image = base64Encode(currentFile.readAsBytesSync());
          _send(ChatMessage(
              fileName: fileName,
              messageType: MessageType.doc,
              senderId: keys!.phone.value,
              content: base64Image,
              recipientId: widget.id));
        }
      }
    } else {
      // User canceled the picker
    }
  }

  bool isImage(filePath) {
    String? mimeType = lookupMimeType(filePath);
    return mimeType != null && mimeType.startsWith('image/');
  }

  Future<void> _saveAndOpenFile(base64File, fileName) async {
    try {
      Uint8List bytes = base64Decode(base64File);

      Directory tempDir = await getTemporaryDirectory();
      String tempPath = tempDir.path;

      String filePath = '$tempPath/$fileName';

      File file = File(filePath);
      await file.writeAsBytes(bytes);

      // OpenFile.open(filePath);
      Get.to(() => PDFScreen(
            path: filePath,
          ));
      // PDFView(
      //   filePath: file.path,
      //   enableSwipe: true,
      //   swipeHorizontal: true,
      //   autoSpacing: false,
      //   pageFling: false,
      //   onRender: (pages) {
      //     setState(() {
      //       // pages = _pages;
      //       // isReady = true;
      //     });
      //   },
      //   onError: (error) {
      //     print(error.toString());
      //   },
      //   onPageError: (page, error) {
      //     print('$page: ${error.toString()}');
      //   },
      //   onViewCreated: (PDFViewController pdfViewController) {
      //     // _controller.complete(pdfViewController);
      //   },
      //   // onPageChanged: (int page?, int total?) {}
      //   //   print('page change: $page/$total');
      // );
    } catch (e) {
      print('Erreur lors de l\'ouverture du fichier: $e');
    }
  }

  void _send(ChatMessage message) async {
    // AppContact? contact = keys!.getContact(widget.id);
    String content = message.content;
    // String cryptedMes = Encryption.encryptMessage(
    //     message: content, publicKey: contact!.publicKey);
    // message.content = cryptedMes;

    //print('PUBLICKEY: ${contact.publicKey}');

    //print(message.toMap());

    stompController.stompClient.send(
      destination: "/app/chat",
      body: json.encode(message.toMap()),
    );

    message.content = content;
    discussionController.addMessageToDiscussionController(message, widget.id);
    _controller.clear();
    print('Sent');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ChatAppBarWidget(
        home: true,
        displayName: widget.displayName,
        id: widget.id,
      ),
      body: Column(children: [
        Expanded(child: Obx(
          () {
            final allMessages =
                discussionController.getDiscussionMessages(widget.id);

            return GroupedListView<ChatMessage, DateTime>(
              padding: const EdgeInsets.all(8.0),
              reverse: true,
              order: GroupedListOrder.DESC,
              useStickyGroupSeparators: true,
              floatingHeader: true,
              elements: allMessages,
              groupBy: (message) => DateTime(message.sentAt!.year,
                  message.sentAt!.month, message.sentAt!.day),
              groupHeaderBuilder: (ChatMessage message) => SizedBox(
                height: 40,
                child: Center(
                    child: Card(
                  color: Theme.of(context).primaryColor,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      DateFormat.yMMMd().format(message.sentAt!),
                    ),
                  ),
                )),
              ),
              itemBuilder: (context, ChatMessage message) => Align(
                alignment: message.senderId == keys!.phone.value
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: message.messageType == MessageType.text
                    ? MessageBubble(
                        message: message,
                      )
                    : message.messageType == MessageType.image
                        ? ImageWidget(
                            message: message,
                            onTap: () {
                              Get.to(() => OpenImage(
                                    message: message,
                                    discussionId: widget.id,
                                    displayName: widget.displayName,
                                  ));
                            },
                          )
                        : DocWidget(
                            onTap: () {
                              _saveAndOpenFile(
                                  message.content, message.fileName);
                            },
                            message: message),
              ),
            );
          },
        )),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: TextField(
                    style: const TextStyle(fontSize: 15, color: Colors.black),
                    controller: _controller,
                    maxLines: 15,
                    minLines: 1,
                    decoration: InputDecoration(
                      suffixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            onPressed: () {
                              _chooseFile();
                            },
                            icon: const Icon(Icons.attach_file),
                          ),
                          IconButton(
                            onPressed: () {
                              _imgFromCamera();
                            },
                            icon: const Icon(
                              Icons.camera_alt,
                            ),
                          ),
                        ],
                      ),
                      hintText: "Votre message ici...",
                      hintStyle: const TextStyle(color: Colors.black),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8.0),
              Container(
                width: 45,
                height: 45,
                padding: const EdgeInsets.all(7),
                decoration: const BoxDecoration(
                  color: color1,
                  shape: BoxShape.circle,
                ),
                child: GestureDetector(
                  onTap: () {
                    if (_controller.text.isNotEmpty) {
                      _send(ChatMessage(
                        fileName: "",
                        messageType: MessageType.text,
                        senderId: keys!.phone.value,
                        content: _controller.text,
                        recipientId: widget.id,
                      ));
                    }
                  },
                  child: Image.asset('assets/icons/send_msg.png'),
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}

class ChatAppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String displayName;
  final bool home;
  final String id;
  const ChatAppBarWidget({
    super.key,
    required this.id,
    required this.displayName,
    required this.home,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leadingWidth: 50,
      centerTitle: false,
      backgroundColor: color1,
      leading: IconButton(
        onPressed: () {
          final controller = Get.find<DiscussionController>();
          controller.reinitUnreadController(id);
          home
              ? Get.to(() => const MyNewHomePage())
              : Get.to(() => (MessagesPage(id: id, displayName: displayName)));
        },
        icon: const Icon(Icons.arrow_back),
      ),
      title: GestureDetector(
        onTap: () {
          Get.to(() => ContactProfilPage(id: id, displayName: displayName));
        },
        child: Row(
          children: [
            IconProfilWidgetContact(
                settingsController: Get.find<SettingsController>(), id: id),
            const SizedBox(
              width: 10,
            ),
            Text(
              displayName,
              style: TextStyle(
                  fontSize: displayName.isAlphabetOnly ? 25 : 20,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      actions: [
        Obx(
          () => FaceIconWidget(
            color: Get.find<SettingsController>().faveVerif.value
                ? color2
                : Colors.white,
            onTap: () {
              Get.find<SettingsController>().changeFaceVerifTemp();
            },
          ),
        ),
        const SizedBox(
          width: 15,
        ),
        // InkWell(
        //   onTap: () {},
        //   child: Image.asset(
        //     'assets/icons/telephone_b.png',
        //     width: 37,
        //     height: 37,
        //   ),
        // ),
        const SizedBox(
          width: 10,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class MessageBubble extends StatelessWidget {
  final ChatMessage message;

  const MessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final timeString = DateFormat('HH:mm').format(message.sentAt!);
    final isSentByMe =
        message.senderId == Get.find<KeyController>().phone.value;

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            message.senderId == Get.find<KeyController>().phone.value
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.8,
            ),
            decoration: BoxDecoration(
              color: isSentByMe ? color2 : color1,
              borderRadius: isSentByMe
                  ? const BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      bottomLeft: Radius.circular(20.0),
                      bottomRight: Radius.circular(20.0),
                    )
                  : const BorderRadius.only(
                      topRight: Radius.circular(20.0),
                      bottomLeft: Radius.circular(20.0),
                      bottomRight: Radius.circular(20.0),
                    ),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    message.content,
                    style: TextStyle(
                      color: isSentByMe ? Colors.white : Colors.black54,
                      fontSize: 15.0,
                    ),
                  ),
                  const SizedBox(height: 2.0),
                  Text(
                    timeString,
                    style: TextStyle(
                      color: isSentByMe ? Colors.white70 : Colors.black45,
                      fontSize: 10.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ImageWidget extends StatelessWidget {
  final VoidCallback onTap;
  const ImageWidget({
    super.key,
    required this.message,
    required this.onTap,
  });

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final timeString = DateFormat('HH:mm').format(message.sentAt!);
    final isSentByMe =
        message.senderId == Get.find<KeyController>().phone.value;

    return GestureDetector(
      onTap: onTap,
      child: Hero(
        tag: 'open-image',
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment:
                message.senderId == Get.find<KeyController>().phone.value
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
            children: [
              Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.8,
                ),
                decoration: BoxDecoration(
                  color: isSentByMe ? color2 : color1,
                  borderRadius: isSentByMe
                      ? const BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          bottomLeft: Radius.circular(20.0),
                          bottomRight: Radius.circular(20.0),
                        )
                      : const BorderRadius.only(
                          topRight: Radius.circular(20.0),
                          bottomLeft: Radius.circular(20.0),
                          bottomRight: Radius.circular(20.0),
                        ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 5.0, horizontal: 7.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Image.memory(
                      //   base64Decode(message.content),
                      // ),
                      Text(
                        message.fileName,
                        style: TextStyle(
                          color: isSentByMe ? Colors.white : Colors.black54,
                          fontSize: 15.0,
                        ),
                      ),
                      const SizedBox(height: 2.0),
                      Text(
                        timeString,
                        style: TextStyle(
                          color: isSentByMe ? Colors.white70 : Colors.black45,
                          fontSize: 10.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DocWidget extends StatelessWidget {
  final VoidCallback onTap;
  const DocWidget({
    super.key,
    required this.onTap,
    required this.message,
  });

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final timeString = DateFormat('HH:mm').format(message.sentAt!);
    final isSentByMe =
        message.senderId == Get.find<KeyController>().phone.value;

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment:
              message.senderId == Get.find<KeyController>().phone.value
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
          children: [
            Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.8,
              ),
              decoration: BoxDecoration(
                color: isSentByMe ? color2 : color1,
                borderRadius: isSentByMe
                    ? const BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        bottomLeft: Radius.circular(20.0),
                        bottomRight: Radius.circular(20.0),
                      )
                    : const BorderRadius.only(
                        topRight: Radius.circular(20.0),
                        bottomLeft: Radius.circular(20.0),
                        bottomRight: Radius.circular(20.0),
                      ),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 5.0, horizontal: 7.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      message.fileName,
                      style: TextStyle(
                        color: isSentByMe ? Colors.white : Colors.black54,
                        fontSize: 15.0,
                      ),
                    ),
                    const SizedBox(height: 2.0),
                    Text(
                      timeString,
                      style: TextStyle(
                        color: isSentByMe ? Colors.white70 : Colors.black45,
                        fontSize: 10.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OpenImage extends StatelessWidget {
  final String displayName;
  final String discussionId;
  final ChatMessage message;
  const OpenImage(
      {super.key,
      required this.message,
      required this.discussionId,
      required this.displayName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ChatAppBarWidget(
        home: false,
        displayName: displayName,
        id: discussionId,
      ),
      body: Hero(
          tag: 'open-image',
          child: Image.memory(base64Decode(message.content))),
    );
  }
}

class PDFScreen extends StatefulWidget {
  final String? path;

  const PDFScreen({Key? key, this.path}) : super(key: key);

  _PDFScreenState createState() => _PDFScreenState();
}

class _PDFScreenState extends State<PDFScreen> with WidgetsBindingObserver {
  final Completer<PDFViewController> _controller =
      Completer<PDFViewController>();
  int? pages = 0;
  int? currentPage = 0;
  bool isReady = false;
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Document"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          PDFView(
            filePath: widget.path,
            enableSwipe: true,
            swipeHorizontal: true,
            autoSpacing: false,
            pageFling: true,
            pageSnap: true,
            defaultPage: currentPage!,
            fitPolicy: FitPolicy.BOTH,
            preventLinkNavigation:
                false, // if set to true the link is handled in flutter
            onRender: (_pages) {
              setState(() {
                pages = _pages;
                isReady = true;
              });
            },
            onError: (error) {
              setState(() {
                errorMessage = error.toString();
              });
              print(error.toString());
            },
            onPageError: (page, error) {
              setState(() {
                errorMessage = '$page: ${error.toString()}';
              });
              print('$page: ${error.toString()}');
            },
            onViewCreated: (PDFViewController pdfViewController) {
              _controller.complete(pdfViewController);
            },
            onLinkHandler: (String? uri) {
              print('goto uri: $uri');
            },
            onPageChanged: (int? page, int? total) {
              print('page change: $page/$total');
              setState(() {
                currentPage = page;
              });
            },
          ),
          errorMessage.isEmpty
              ? !isReady
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Container()
              : Center(
                  child: Text(errorMessage),
                )
        ],
      ),
      floatingActionButton: FutureBuilder<PDFViewController>(
        future: _controller.future,
        builder: (context, AsyncSnapshot<PDFViewController> snapshot) {
          if (snapshot.hasData) {
            return FloatingActionButton.extended(
              label: Text("Go to ${pages! ~/ 2}"),
              onPressed: () async {
                await snapshot.data!.setPage(pages! ~/ 2);
              },
            );
          }

          return Container();
        },
      ),
    );
  }
}
