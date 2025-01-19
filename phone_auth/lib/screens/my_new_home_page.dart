import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phone_auth/const.dart';
import 'package:phone_auth/controllers/get_controllers/settings_controller.dart';
import 'package:phone_auth/recognizer_widget.dart';
import 'package:phone_auth/screens/auth_page.dart';
//import 'package:phone_auth/screens/call_page.dart';
import 'package:phone_auth/screens/contact_page.dart';
import 'package:phone_auth/screens/discussion_page.dart';
//import 'package:phone_auth/screens/groupe_page.dart';
import 'package:phone_auth/screens/settings/settings_screen.dart';

class MyNewHomePage extends StatefulWidget {
  const MyNewHomePage({super.key});

  @override
  State<MyNewHomePage> createState() => _MyNewHomePageState();
}

class _MyNewHomePageState extends State<MyNewHomePage> {
  final _pageControlller = PageController();
  int _index = 0;
  Color bottomBarColor = const Color(0xFF4E057E);

  Color appBarColor = Get.find<SettingsController>().settings['darkTheme']
      ? Colors.black
      : Colors.white;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(),
      bottomNavigationBar: Obx(
        () => CurvedNavigationBar(
          index: _index,
          items: [
            CurvedNavigationBarItem(
              child: Image.asset(
                'assets/icons/messages.png',
                height: 20,
                width: 20,
              ),
              label: 'Chats',
            ),
            // CurvedNavigationBarItem(
            //   child: Image.asset(
            //     'assets/icons/users.png',
            //     height: 20,
            //     width: 20,
            //   ),
            //   label: 'Groupes',
            // ),
            // CurvedNavigationBarItem(
            //   child: Image.asset(
            //     'assets/icons/telephone.png',
            //     height: 20,
            //     width: 20,
            //   ),
            //   label: 'Appels',
            // ),
            CurvedNavigationBarItem(
              child: Image.asset(
                'assets/icons/settings.png',
                height: 20,
                width: 20,
              ),
              label: 'Param...',
            ),
          ],
          color: Get.find<SettingsController>()
              .colors[1], // const Color(0xFF4E057E),
          buttonBackgroundColor: const Color(0xFFE167D0),
          backgroundColor: const Color(0xFFFBE8E8),
          onTap: (index) {
            setState(() {
              _pageControlller.animateToPage(index,
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeOut);
            });
          },
          letIndexChange: (index) => true,
        ),
      ),
      body: Obx(
        () {
          if (Get.find<SettingsController>().faveVerif.value == false) {
            return PageView(
              onPageChanged: (index) {
                setState(() {
                  _index = index;
                });
              },
              controller: _pageControlller,
              children: const <Widget>[
                DiscussionPage(),
                // GroupePage(),
                //CallPage(),
                Settings(),
              ],
            );
          } else {
            return Stack(
              children: [
                FaceRecognizer(onRecongized: (value) {
                  // print(value);
                  switch (value) {
                    case 3:
                      // print('may  change now');
                      Get.off(() => const AuthPage());
                      break;
                    case 2:
                      Get.find<SettingsController>().changeColor();
                      break;
                    default:
                      Get.find<SettingsController>().reinitColor();
                      break;
                  }
                }),
                PageView(
                  onPageChanged: (index) {
                    setState(() {
                      _index = index;
                    });
                  },
                  controller: _pageControlller,
                  children: const <Widget>[
                    DiscussionPage(),
                    // GroupePage(),
                    //CallPage(),
                    Settings(),
                  ],
                ),
              ],
            );
          }
        },
      ),
    );
  }
}

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const AppBarWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => AppBar(
        backgroundColor:
            Get.find<SettingsController>().colors[0], // appBarColor,
        leading: Container(
          margin: const EdgeInsets.only(left: 7),
          child: FaceIconWidget(
            color: Get.find<SettingsController>().faveVerif.value
                ? color2
                : Colors.white,
            onTap: () {
              Get.find<SettingsController>().changeFaceVerifTemp();
            },
          ),
        ),

        actions: [
          IconButton(
              onPressed: () {
                Get.to(() => const ContactScreen());
              },
              icon: const Icon(
                Icons.add,
                size: 50,
              ))
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
