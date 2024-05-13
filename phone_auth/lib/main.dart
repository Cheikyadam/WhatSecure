import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:phone_auth/controllers/get_controllers/chat_controller.dart';
import 'package:phone_auth/controllers/get_controllers/discussion_controller.dart';
import 'package:phone_auth/controllers/get_controllers/keys_controller.dart';
import 'package:phone_auth/controllers/hive_controller/hive_helper.dart';
import 'package:phone_auth/screens/home.dart';
import 'firebase_options.dart';
import 'screens/login_page.dart';
import 'package:get_storage/get_storage.dart';
import 'screens/name_page.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await GetStorage.init();
  await DiscussionHelper.setupDatabase();
  await ChatMessageHelper.setupDatabase();
  await AppContactHelper.setupDatabase();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => DiscussionController);
    Get.lazyPut(() => ChatController);
    Get.lazyPut(() => KeyController());
    final box = GetStorage();
    final isVerified = box.read('verified');
    final isConnected = box.read('connected');
    final phone = box.read('phone');
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      home: isConnected == null
          ? (isVerified == null
              ? const Login()
              : NamePage(
                  phone: phone.toString(),
                ))
          : const HomePage(),
      /*initialBinding: BindingsBuilder(() {
        Get.put(DiscussionController());
        Get.put(ChatController);
      }),*/
    );
  }
}
