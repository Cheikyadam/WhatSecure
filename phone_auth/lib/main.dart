import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:phone_auth/controllers/get_controllers/discussion_controller.dart';
import 'package:phone_auth/controllers/get_controllers/keys_controller.dart';
import 'package:phone_auth/controllers/get_controllers/settings_controller.dart';
import 'package:phone_auth/controllers/get_controllers/stomp_controller.dart';
import 'package:phone_auth/controllers/hive_controller/hive_helper.dart';
import 'package:phone_auth/const.dart';
import 'package:camera/camera.dart';
import 'package:phone_auth/screens/ins_page.dart';
import 'package:phone_auth/screens/my_new_home_page.dart';
import 'package:phone_auth/themes/themes.dart';
import 'firebase_options.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await GetStorage.init();
  await DiscussionHelper.setupDatabase();
  await AppContactHelper.setupDatabase();
  await ChatMessageHelper.setupDatabase();
  await RecognitionHelper.setupDatabase();
  cameras = await availableCameras();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    GetStorage().writeIfNull('settings',
        {'darkTheme': false, 'contacts': false, 'faceVerif': false});
    Get.put(SettingsController());
    final box = GetStorage();
    // box.write('isVerified', false);
    bool? isVerified = box.read('isVerified');
    // bool? isConnected = box.read('connected');
    // final phone = box.read('phone');
    if (isVerified != null && isVerified != false) {
      //isConnected != null && isConnected != false) {

      Get.put(KeyController());
      Get.put(DiscussionController());
      Get.put(StompController());

      loaded = true;
    }
    return Obx(() {
      DiscussionHelper.initAllDiscussion();
      return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: Get.find<SettingsController>().settings['darkTheme']
            ? darkTheme
            : lightTheme,
        home: //isConnected == null || isConnected == false?
            (isVerified == null || isVerified == false
                ? const InsPage()
                // : NamePage(
                //     phone: phone.toString(),
                //   ))
                : const MyNewHomePage()),
      );
    });
  }
}
