import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phone_auth/const.dart';
import 'package:phone_auth/controllers/get_controllers/settings_controller.dart';
import 'package:phone_auth/screens/settings/face_save.dart';
import 'package:switcher_button/switcher_button.dart';

class FaceVerif extends StatelessWidget {
  FaceVerif({super.key});
  final SettingsController settingsControllers = Get.find<SettingsController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              VerifWidgets(
                color1: color1,
                text: 'Enregistrer a nouveau votre face',
                onTap: () {
                  Get.to(() => const FaceSave(
                        text: 'Cliquer pour enregistrer',
                      ));
                },
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                margin: const EdgeInsets.all(5),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: color1,
                    border: Border.all(width: 1),
                    borderRadius: BorderRadius.circular(12)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Activé par défaut',
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: 50,
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: SwitcherButton(
                          value: settingsControllers.settings['faceVerif'],
                          onChange: (value) {
                            settingsControllers.changeFaceVerif(value);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              )
              //sVerifWidgets(text: 'Activer', onTap: () {}, color1: color1)
            ],
          ),
        ),
      ),
    );
  }
}

class VerifWidgets extends StatelessWidget {
  final VoidCallback onTap;
  final String text;
  const VerifWidgets({
    super.key,
    required this.text,
    required this.onTap,
    required Color color1,
  }) : _color1 = color1;

  final Color _color1;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: _color1,
            borderRadius: const BorderRadius.all(Radius.circular(25))),
        width: MediaQuery.of(context).size.width * 0.9,
        child: Center(
          child: Text(
            textAlign: TextAlign.center,
            text,
            style: const TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }
}
