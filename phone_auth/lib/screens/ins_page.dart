import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:phone_auth/const.dart';
import 'package:phone_auth/controllers/auth_service.dart';
import 'package:phone_auth/controllers/user_api/user_api.dart';
import 'package:phone_auth/encryption/rsa_encryption.dart';
import 'package:phone_auth/models/user_model.dart';
import 'package:phone_auth/screens/settings/face_save.dart';

/*class InsPage extends StatefulWidget {
  const InsPage({super.key});

  @override
  State<InsPage> createState() => _InsPageState();
}

class _InsPageState extends State<InsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Center(
              child: Text(
                'Bienvenue sur',
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
              ),
            ),
            const Center(
              child: Text(
                'WhatSecure',
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            const Center(
              child: Text(
                'Inscription',
                style: TextStyle(
                  fontSize: 30,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
              decoration: const BoxDecoration(
                  color: Color(0xFFC5B8CE),
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.all(15),
                    padding: const EdgeInsets.only(left: 20),
                    decoration: const BoxDecoration(
                        color: Color(0xA3FFFFFF),
                        borderRadius: BorderRadius.all(Radius.circular(25))),
                    child: TextFormField(
                      style: const TextStyle(fontSize: 20, color: Colors.black),
                      decoration: const InputDecoration(
                        label: Text(
                          'Numero de telephone',
                          style: TextStyle(fontSize: 20),
                        ),
                        prefixIcon: Icon(Icons.call),
                        prefixText: '+212',
                        prefixStyle:
                            TextStyle(color: Colors.black, fontSize: 20),
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(15),
                    padding: const EdgeInsets.only(left: 20),
                    decoration: const BoxDecoration(
                        color: Color(0xA3FFFFFF),
                        borderRadius: BorderRadius.all(Radius.circular(25))),
                    child: TextFormField(
                      style: const TextStyle(fontSize: 20, color: Colors.black),
                      decoration: const InputDecoration(
                        icon: Icon(Icons.person),
                        label: Text(
                          'Nom d\'utilisateur',
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            ElevatedButton(
                onPressed: () {},
                child: const Text(
                  'Obtenir le code',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ))
          ],
        ),
      ),
    );
  }
}
*/

class InsPage extends StatefulWidget {
  const InsPage({super.key});

  @override
  State<InsPage> createState() => _InsPageState();
}

class _InsPageState extends State<InsPage> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _formKey1 = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    GetStorage().writeIfNull('isVerified', false);
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              'assets/icons/logo.png',
              width: MediaQuery.of(context).size.width * 0.50,
              height: MediaQuery.of(context).size.width * 0.50,
            ),
            const SizedBox(
              height: 20,
            ),
            const Center(
              child: Text(
                'Inscription',
                style: TextStyle(
                    fontSize: 40,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
              decoration: const BoxDecoration(
                  color: Color(0xFFC5B8CE),
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(15),
                      padding: const EdgeInsets.only(left: 20),
                      decoration: const BoxDecoration(
                          color: Color(0xA3FFFFFF),
                          borderRadius: BorderRadius.all(Radius.circular(25))),
                      child: TextFormField(
                        keyboardType: TextInputType.phone,
                        controller: _phoneController,
                        style: const TextStyle(
                            fontSize: 18,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                        decoration: const InputDecoration(
                          label: Text(
                            'Numero de telephone',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 18,
                            ),
                          ),
                          prefixIcon: Icon(Icons.call),
                          prefixText: '+212',
                          prefixStyle: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        validator: (value) {
                          if (value!.length != 9) {
                            return "Numero de telephone non valide";
                          }
                          if (!value.isNumericOnly) {
                            return "Numero de telephone non valide";
                          }
                          return null;
                        },
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(15),
                      padding: const EdgeInsets.only(left: 20),
                      decoration: const BoxDecoration(
                          color: Color(0xA3FFFFFF),
                          borderRadius: BorderRadius.all(Radius.circular(25))),
                      child: TextFormField(
                        controller: _nameController,
                        style:
                            const TextStyle(fontSize: 18, color: Colors.black),
                        decoration: const InputDecoration(
                          icon: Icon(Icons.person),
                          label: Text(
                            'Nom d\'utilisateur',
                            style: TextStyle(
                                fontSize: 18,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          border: InputBorder.none,
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Nom d'utilisateur requis";
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    AuthService.sentOtp(
                      phone: _phoneController.text,
                      errorStep: () => ScaffoldMessenger.of(context)
                          .showSnackBar(const SnackBar(
                        duration: Duration(seconds: 5),
                        content: Text(
                          "Une erreur est survenue, veuillez reesayer plus tard",
                          style: TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Colors.red,
                      )),
                      nextStep: () => showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Verification du code OTP'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Entrer OTP à 6 chiffres'),
                              const SizedBox(
                                height: 20,
                              ),
                              Form(
                                key: _formKey1,
                                child: TextFormField(
                                  controller: _otpController,
                                  keyboardType: TextInputType.phone,
                                  decoration: InputDecoration(
                                      labelText: 'Entrer le code',
                                      labelStyle: const TextStyle(fontSize: 20),
                                      //fillColor: Colors.white,
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(32))),
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
                                if (_formKey1.currentState!.validate()) {
                                  AuthService.loginWithOtp(
                                          otp: _otpController.text)
                                      .then((value) {
                                    if (value == "Success") {
                                      Navigator.pop(context);
                                      final name = _nameController.text;
                                      final phone =
                                          "+212${_phoneController.text}";
                                      Get.offAll(() => LoadingPage(
                                            phone: phone,
                                            name: name,
                                          ));
                                    } else {
                                      Navigator.pop(context);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text(
                                          value,
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                        backgroundColor: Colors.red,
                                      ));
                                    }
                                  });
                                }
                              },
                              child: const Text(
                                'Verifier',
                                style: TextStyle(fontSize: 20),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  }
                  // }
                },
                child: const Text(
                  'Obtenir le code',
                  style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Montserrat',
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ))
          ],
        ),
      ),
    );
  }
}

class LoadingPage extends StatelessWidget {
  final String name;
  final String phone;
  const LoadingPage({super.key, required this.name, required this.phone});

  Future<bool> createUser(String phoneNumber, String username) async {
    final publiKey = await Encryption.keyPairGeneration();
    final newUser = User(id: phoneNumber, name: username, publicKey: publiKey);
    final result = await Api.addUser(newUser.toMap());
    if (result['code'] == 200) {
      return true;
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: FutureBuilder<bool>(
              future: createUser(phone, name),
              builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else {
                  if (snapshot.hasError) {
                    return Card(
                      child: TextButton(
                        onPressed: () {
                          Get.offAll(() => const InsPage());
                        },
                        child: const Text(
                          'Une erreur est survenue, veuillez reesayer plus tard',
                          style: TextStyle(color: Colors.red, fontSize: 20),
                        ),
                      ),
                    );
                  } else {
                    if (snapshot.data == false) {
                      return Card(
                        child: Container(
                          alignment: Alignment.center,
                          height: 80,
                          padding: const EdgeInsets.all(5),
                          margin: const EdgeInsets.all(5),
                          decoration: const BoxDecoration(
                              color: color1,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                          child: TextButton(
                            onPressed: () {
                              Get.offAll(() => const InsPage());
                            },
                            child: const Center(
                              child: Text(
                                'Une erreur est survenue, veuillez reesayer plus tard',
                                style: TextStyle(
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    } else {
                      final box = GetStorage();
                      box.write('isVerified', true);
                      box.write("phone", phone);
                      box.write('username', name);
                      box.write('profilPictureIsSet', false);
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        Get.offAll(() => const FaceSave(
                              text: 'Cliquer pour enregistrer votre visage',
                            ));
                      });
                      return Container();
                      // return const MyNewHomePage();
                    }
                  }
                }
              })),
    );
  }
}

class AvantIns extends StatelessWidget {
  const AvantIns({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Column(children: [
            const Center(
              child: Text(
                textAlign: TextAlign.center,
                'Bienvenue sur WhatSecure',
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Image.asset('assets/icons/logo.png'),
            const SizedBox(
              height: 50,
            ),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xffd786a8).withOpacity(0.4)),
                onPressed: () {
                  Get.offAll(() => const InsPage());
                },
                child: const Text(
                  'Inscription',
                  style: TextStyle(fontSize: 30, color: Colors.black),
                ),
              ),
            ),
          ]),
        ));
  }
}
