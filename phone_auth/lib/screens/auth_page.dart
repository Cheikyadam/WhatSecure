import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:phone_auth/screens/my_new_home_page.dart';
import 'package:local_auth_android/local_auth_android.dart';

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
            'Authentification requise pour acceder a l\'application',
        options: const AuthenticationOptions(
          stickyAuth: true,

          //biometricOnly: true,
        ),
        authMessages: const <AuthMessages>[
          AndroidAuthMessages(
            signInTitle: 'Pour plus de securite, veuillez vous authentifier',
            cancelButton: 'Non merci!',
          ),
        ],
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
                Get.offAll(() => const MyNewHomePage());
              });
              return myWidget(context);
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
      //appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset('assets/icons/logo.png'),
            TextButton(
                onPressed: () async {
                  await _authenticateWithBiometrics();
                  if (_authenticated) {
                    Get.offAll(() => const MyNewHomePage());
                  }
                },
                child: const Text(
                  "Verifier votre identité",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                )),
          ],
        ),
      ),
    );
  }
}
