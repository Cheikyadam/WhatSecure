import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:phone_auth/controllers/auth_service.dart';
import 'package:phone_auth/controllers/get_controllers/keys_controller.dart';
import 'package:phone_auth/controllers/get_controllers/settings_controller.dart';
import 'package:phone_auth/const.dart';
import 'package:phone_auth/controllers/user_api/user_api.dart';
import 'package:phone_auth/screens/ins_page.dart';
import 'package:phone_auth/screens/message_page.dart';
import 'package:phone_auth/screens/settings/face_verif.dart';
import 'package:phone_auth/screens/settings/modif_profile.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final settingsController = Get.find<SettingsController>();

  @override
  void initState() {
    super.initState();
    settingsController.changeImageUrl();
  }

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
                InkWell(
                  onTap: () {
                    Get.to(() => const Modifprofile(
                          first: false,
                        ));
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.9,
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
                        IconProfilWidget(
                            settingsController: settingsController),
                        const SizedBox(
                          width: 15,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Modifier Photo de profil',
                              style: TextStyle(fontSize: 18),
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
                                style: const TextStyle(fontSize: 17),
                              )
                            ])
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: PlainWidget(
                    onTap: () {
                      Get.to(() => const ModifInfosPersonnelles());
                    },
                    text: 'Modifier les infos personnelles',
                    imageAsset: 'assets/icons/recycler.png',
                  ),
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
                    // InkWell(
                    //   onTap: () {},
                    //   child: Container(
                    //       margin: const EdgeInsets.all(8.0),
                    //       height: 80,
                    //       width: MediaQuery.of(context).size.width * 0.4,
                    //       decoration: const BoxDecoration(
                    //           color: color1,
                    //           borderRadius:
                    //               BorderRadius.all(Radius.circular(10))),
                    //       padding: const EdgeInsets.all(4.0),
                    //       child: Column(
                    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //         children: [
                    //           Image.asset(
                    //             'assets/icons/bloquer.png',
                    //             width: 45,
                    //             height: 45,
                    //           ),
                    //           const Text(
                    //             ' Contacts bloques',
                    //             style: TextStyle(
                    //               fontSize: 15,
                    //             ),
                    //           ),
                    //         ],
                    //       )),
                    // ),
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
                // PlainWidget(
                //     onTap: () {},
                //     text: 'Supprimer mon compte',
                //     imageAsset: 'assets/icons/poubelle.png'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class IconProfilWidget extends StatelessWidget {
  const IconProfilWidget({
    super.key,
    required this.settingsController,
  });

  final SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Obx(
        () => Image.network(
          settingsController.imageUrl.value,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color.fromARGB(255, 230, 230, 230)),
            child: Image.asset(
              'assets/icons/profil.png',
              width: 45,
              height: 45,
              fit: BoxFit.cover,
            ),
          ),
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) {
              return child;
            } else {
              return Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          (loadingProgress.expectedTotalBytes ?? 1)
                      : null,
                ),
              );
            }
          },
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
        margin: const EdgeInsets.only(bottom: 10.0),
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

class ModifInfosPersonnelles extends StatefulWidget {
  const ModifInfosPersonnelles({super.key});

  @override
  State<ModifInfosPersonnelles> createState() => _ModifInfosPersonnellesState();
}

class _ModifInfosPersonnellesState extends State<ModifInfosPersonnelles> {
  final TextEditingController _nameController = TextEditingController();
  bool _isTextFieldEnabled = false;
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  bool _isPhoneFieldEnabled = false;
  final _formKey = GlobalKey<FormState>();
  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();

  void _toggleTextField() {
    setState(() {
      _isTextFieldEnabled = !_isTextFieldEnabled;
      if (!_isTextFieldEnabled) {
        _nameController.clear();
      }
    });
  }

  void _togglePhoneField() {
    setState(() {
      _isPhoneFieldEnabled = !_isPhoneFieldEnabled;
      if (!_isTextFieldEnabled) {
        _phoneController.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vos infos personnelles'),
        actions: const [
          FaceIconWidgetObs(),
          SizedBox(
            width: 10,
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 25,
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.95,
            padding: const EdgeInsets.only(left: 15),
            decoration: const BoxDecoration(
                color: color1,
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: Form(
                    key: _formKey,
                    child: Obx(
                      () => TextFormField(
                        style:
                            const TextStyle(fontSize: 20, color: Colors.black),
                        onFieldSubmitted: (value) async {
                          if (_formKey.currentState!.validate()) {
                            var response = await Api.updateUsername(
                                {"name": value},
                                Get.find<KeyController>()
                                    .phone
                                    .value
                                    .toString());
                            if (response["code"] == 200) {
                              Get.find<KeyController>().changeUsername(value);
                            } else {
                              const GetSnackBar(
                                duration: Duration(seconds: 3),
                                messageText: Text(
                                  "Une erreur est survenue, veuillez reesayer plus tard",
                                  style: TextStyle(color: Colors.red),
                                ),
                              );
                            }
                            _nameController.clear();
                          }
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Le nom ne peut pas etre vide';
                          }
                          return null;
                        },
                        controller: _nameController,
                        enabled: _isTextFieldEnabled,
                        decoration: InputDecoration(
                          hintText: Get.find<KeyController>().username.value,
                          icon: const Icon(Icons.person),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: IconButton(
                      onPressed: () {
                        _toggleTextField();
                      },
                      icon: const Icon(
                        Icons.edit,
                      )),
                ),
              ],
            ),
          ),
          Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.only(left: 15),
              width: MediaQuery.of(context).size.width * 0.95,
              decoration: const BoxDecoration(
                  color: color1,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: Form(
                      key: _formKey1,
                      child: Obx(
                        () => TextFormField(
                            style: const TextStyle(
                                fontSize: 20, color: Colors.black),
                            onFieldSubmitted: (value) {
                              if (_formKey1.currentState!.validate()) {
                                AuthService.sentOtp(
                                    phone: value.substring(4, value.length),
                                    errorStep: () =>
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                          duration: Duration(seconds: 5),
                                          content: Text(
                                            "Une erreur est survenue, veuillez reesayer plus tard",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          backgroundColor: Colors.red,
                                        )),
                                    nextStep: () => showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: const Text(
                                                'Verification du code OTP'),
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                    'Entrer OTP à 6 chiffres'),
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                                Form(
                                                  key: _formKey2,
                                                  child: TextFormField(
                                                    controller: _otpController,
                                                    keyboardType:
                                                        TextInputType.phone,
                                                    decoration: InputDecoration(
                                                        labelText:
                                                            'Entrer le code',
                                                        labelStyle:
                                                            const TextStyle(
                                                                fontSize: 20),
                                                        border: OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        32))),
                                                    validator: (value) {
                                                      if (value!.length != 6) {
                                                        return "OTP invalide";
                                                      }
                                                      return null;
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  if (_formKey2.currentState!
                                                      .validate()) {
                                                    AuthService.loginWithOtp(
                                                            otp: _otpController
                                                                .text)
                                                        .then((value) async {
                                                      if (value == "Success") {
                                                        final result = await Api
                                                            .updateUserPhone(
                                                                {
                                                              'phone':
                                                                  _phoneController
                                                                      .text
                                                            },
                                                                Get.find<
                                                                        KeyController>()
                                                                    .phone
                                                                    .value
                                                                    .toString());
                                                        if (result['code'] ==
                                                            200) {
                                                          Get.find<
                                                                  KeyController>()
                                                              .changeUserPhone(
                                                                  _phoneController
                                                                      .text);
                                                        } else {
                                                          const GetSnackBar(
                                                            messageText: Text(
                                                              'Une erreur est survenue',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .red),
                                                            ),
                                                          );
                                                        }
                                                        Navigator.pop(context);
                                                        _phoneController
                                                            .clear();
                                                      } else {
                                                        Navigator.pop(context);
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                                SnackBar(
                                                          content: Text(
                                                            value,
                                                            style:
                                                                const TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                          ),
                                                          backgroundColor:
                                                              Colors.red,
                                                        ));
                                                      }
                                                    });
                                                  }
                                                },
                                                child: const Text(
                                                  'Verifier',
                                                  style:
                                                      TextStyle(fontSize: 20),
                                                ),
                                              )
                                            ],
                                          ),
                                        ));
                              }
                            },
                            validator: (value) {
                              if (!value!.startsWith("+212")) {
                                return "Numero de telephone non valide";
                              }
                              final myValue = value.substring(4, value.length);
                              if (myValue.length != 9) {
                                return "Numero de telephone non valide";
                              }
                              if (!myValue.isNumericOnly) {
                                return "Numero de telephone non valide";
                              }
                              return null;
                            },
                            enabled: _isPhoneFieldEnabled,
                            controller: _phoneController,
                            decoration: InputDecoration(
                                hintText: Get.find<KeyController>().phone.value,
                                border: InputBorder.none,
                                icon: const Icon(Icons.call))),
                      ),
                    ),
                  ),
                  Expanded(
                    child: IconButton(
                        onPressed: () {
                          _togglePhoneField();
                        },
                        icon: const Icon(
                          Icons.edit,
                        )),
                  )
                ],
              )),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.95,
            child: PlainWidget(
                text: 'Supprimer mon compte',
                imageAsset: 'assets/icons/poubelle.png',
                onTap: () {
                  _showConfirmationDialog(context);
                }),
          )
        ],
      ),
    );
  }

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmation'),
          content: const Text('Voulez vous vraiment supprimer votre compte'),
          actions: <Widget>[
            TextButton(
              child: const Text('Non'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: const Text('Oui'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    ).then((result) {
      if (result != null && result) {
        Get.offAll(() => const DeletePage());
      } else {}
    });
  }
}

class DeletePage extends StatefulWidget {
  const DeletePage({super.key});

  @override
  State<DeletePage> createState() => _DeletePageState();
}

class _DeletePageState extends State<DeletePage> {
  Future<bool> _deleteAll() async {
    final box = GetStorage();
    final userId = box.read('phone');
    box.erase();
    AndroidOptions getAndroidOptions() => const AndroidOptions(
          encryptedSharedPreferences: true,
        );
    final storage = FlutterSecureStorage(aOptions: getAndroidOptions());
    await storage.deleteAll();
    final recog = await Hive.openBox("recognitions");
    await recog.clear();
    await Api.deleteUser(userId);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
        future: _deleteAll(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            // Si la Future se termine avec une erreur, afficher un message d'erreur
            return Center(child: Text('Erreur: ${snapshot.error}'));
          } else {
            // Si la Future se termine avec succès, afficher les données
            if (snapshot.data == true) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Get.offAll(() => const InsPage());
              });
              return Container();
            } else {
              return const CircularProgressIndicator();
            }
          }
        });
  }
}
