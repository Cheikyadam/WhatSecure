import 'package:flutter/material.dart';
import 'package:phone_auth/const.dart';
import 'package:phone_auth/screens/call_page.dart';
import 'package:phone_auth/screens/discussion_page.dart';
import 'package:phone_auth/screens/groupe_page.dart';
import 'package:phone_auth/screens/settings/settings_screen.dart';
import 'package:rolling_bottom_bar/rolling_bottom_bar.dart';
import 'package:rolling_bottom_bar/rolling_bottom_bar_item.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _pageControlller = PageController();

  @override
  void dispose() {
    _pageControlller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(),
      body: PageView(
        onPageChanged: (index) {},
        controller: _pageControlller,
        children: const <Widget>[
          DiscussionPage(),
          GroupePage(),
          CallPage(),
          Settings()
        ],
      ),
      extendBody: true,
      bottomNavigationBar: RollingBottomBar(
        color: color2,
        controller: _pageControlller,
        flat: true,
        useActiveColorByDefault: false,
        items: const [
          RollingBottomBarItem(Icons.message,
              label: 'Chats', activeColor: color1),
          RollingBottomBarItem(Icons.group,
              label: 'Groupes', activeColor: color1),
          RollingBottomBarItem(Icons.call,
              label: 'Appels', activeColor: color1),
          RollingBottomBarItem(Icons.settings,
              label: 'Param...', activeColor: color1)
        ],
        enableIconRotation: true,
        onTap: (index) {
          _pageControlller.animateToPage(index,
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOut);
        },
      ),
    );
  }
}
