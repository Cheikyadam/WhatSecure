import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phone_auth/screens/settings/face_verif.dart';
import 'package:phone_auth/screens/settings/registration_page.dart';

class FaceSave extends StatelessWidget {
  final String text;
  const FaceSave({super.key, required this.text});

  final Color _color1 = const Color(0xFFC5B8CE);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.5,
                height: MediaQuery.of(context).size.width * 0.5,
                padding: const EdgeInsets.all(30),
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 230, 230, 230),
                  shape: BoxShape.circle,
                ),
                child: Image.asset(
                  'assets/icons/face.png',
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 25),
              VerifWidgets(
                  text: text,
                  onTap: () {
                    Get.offAll(() => const Registration());
                  },
                  color1: _color1)
            ],
          ),
        ),
      ),
    );
  }
}
