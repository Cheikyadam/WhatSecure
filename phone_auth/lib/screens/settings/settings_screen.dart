import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phone_auth/controllers/get_controllers/keys_controller.dart';
import 'package:phone_auth/controllers/get_controllers/settings_controller.dart';
import 'package:phone_auth/const.dart';
import 'package:phone_auth/screens/settings/face_verif.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final settingsController = Get.find<SettingsController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Obx(
          () => SafeArea(
            child: Column(
              children: [
                const Center(
                  child: Text(
                    'Parametres',
                    style: TextStyle(fontSize: 45, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  margin: const EdgeInsets.all(20.0),
                  decoration: const BoxDecoration(
                      color: color1,
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 15,
                      ),
                      Container(
                        width: 45,
                        height: 45,
                        margin: const EdgeInsets.only(right: 8),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Container(
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
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Mon Profil',
                            style: TextStyle(
                                //color: Colors.white,
                                fontSize: 18),
                          ),
                          Row(children: [
                            const Text(
                              'Username: ',
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            Text(
                              Get.find<KeyController>().username.value,
                              style: const TextStyle(
                                  //color: Colors.white,
                                  fontSize: 17),
                            )
                          ])
                        ],
                      )
                    ],
                  ),
                ),
                PlainWidget(
                  onTap: () {},
                  text: 'Changer de numero de telephone',
                  imageAsset: 'assets/icons/recycler.png',
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        settingsController.setThemeToDark();
                      },
                      child: Container(
                          margin: const EdgeInsets.all(8.0),
                          width: MediaQuery.of(context).size.width * 0.4,
                          height: 80,
                          decoration: BoxDecoration(
                              color: settingsController.settings['darkTheme']
                                  ? color2
                                  : color1,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10))),
                          padding: const EdgeInsets.all(4.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Image.asset(
                                'assets/icons/dark.png',
                                width: 45,
                                height: 45,
                              ),
                              const Text(
                                'Theme sombre',
                                style: TextStyle(
                                  fontSize: 15,
                                  // color: Colors.white
                                ),
                              ),
                            ],
                          )),
                    ),
                    InkWell(
                      onTap: () {
                        settingsController.setThemeToLight();
                      },
                      child: Container(
                          margin: const EdgeInsets.all(8.0),
                          height: 80,
                          width: MediaQuery.of(context).size.width * 0.4,
                          decoration: BoxDecoration(
                              color: settingsController.settings['darkTheme']
                                  ? color1
                                  : color2,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10))),
                          padding: const EdgeInsets.all(4.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Image.asset(
                                'assets/icons/palette.png',
                                width: 45,
                                height: 45,
                              ),
                              const Text(
                                'Theme clair',
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          )),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {},
                      child: Container(
                          margin: const EdgeInsets.all(8.0),
                          height: 80,
                          width: MediaQuery.of(context).size.width * 0.4,
                          decoration: const BoxDecoration(
                              color: color1,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          padding: const EdgeInsets.all(4.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Image.asset(
                                'assets/icons/bloquer.png',
                                width: 45,
                                height: 45,
                              ),
                              const Text(
                                ' Contacts bloques',
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          )),
                    ),
                    InkWell(
                      onTap: () {
                        Get.to(() => FaceVerif());
                      },
                      child: Container(
                        margin: const EdgeInsets.all(8.0),
                        height: 80,
                        width: MediaQuery.of(context).size.width * 0.4,
                        decoration: const BoxDecoration(
                            color: color1,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        padding: const EdgeInsets.all(4.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            FaceIconWidget(
                              onTap: () {
                                Get.to(() => FaceVerif());
                              },
                              color:
                                  Get.find<SettingsController>().faveVerif.value
                                      ? color2
                                      : Colors.white,
                            ),
                            const Text(
                              'Face Verification',
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                PlainWidget(
                    onTap: () {},
                    text: 'Supprimer mon compte',
                    imageAsset: 'assets/icons/poubelle.png'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FaceIconWidget extends StatelessWidget {
  final VoidCallback onTap;
  final Color color;
  const FaceIconWidget({super.key, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 45,
        height: 45,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
        child: Image.asset(
          'assets/icons/face.png',
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

class PlainWidget extends StatelessWidget {
  final String text;
  final String imageAsset;
  final VoidCallback onTap;
  const PlainWidget(
      {super.key,
      required this.text,
      required this.imageAsset,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(20.0),
        decoration: const BoxDecoration(
            color: Color(0xFFC5B8CE),
            borderRadius: BorderRadius.all(Radius.circular(10))),
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Image.asset(
              imageAsset,
              width: 40,
              height: 40,
            ),
            Text(
              text,
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
