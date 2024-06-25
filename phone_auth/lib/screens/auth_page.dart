import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:phone_auth/screens/my_new_home_page.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final LocalAuthentication auth = LocalAuthentication();
  bool _authenticated = false;
  Future<bool> _authenticateWithBiometrics() async {
    try {
      bool authenticated = await auth.authenticate(
        localizedReason:
            'Scan your fingerprint (or face or whatever) to authenticate',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
      _authenticated = authenticated;
      return authenticated;
    } on PlatformException catch (e) {
      print(e);
      return false;
    }
    /* if (!mounted) {
      return false;
    }
    return false;*/
  }

  @override
  void initState() {
    super.initState();
    // _authenticateWithBiometrics();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
        future: _authenticateWithBiometrics(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return myWidget(context);
          } else if (snapshot.hasError) {
            // Si la Future se termine avec une erreur, afficher un message d'erreur
            return Center(child: Text('Erreur: ${snapshot.error}'));
          } else {
            // Si la Future se termine avec succès, afficher les données
            if (snapshot.data == true) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Get.off(() => const MyNewHomePage());
              });
              return Container();
            } else {
              return myWidget(context);
            }
          }
        });
    /*if (_authenticated) {
      return const Home();
    }
    return Scaffold(
      body: Center(
        child: TextButton(
            onPressed: () async {
              await _authenticateWithBiometrics();
              if (_authenticated) {
                Navigator.push(context,
                    (MaterialPageRoute(builder: (context) => const Home())));
              }
            },
            child: const Text(
              "Authenticate",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            )),
      ),
    );
  }*/
  }

  Widget myWidget(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
            onPressed: () async {
              await _authenticateWithBiometrics();
              if (_authenticated) {
                Get.off(() => const MyNewHomePage());
              }
            },
            child: const Text(
              "Authenticate",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            )),
      ),
    );
  }
}
