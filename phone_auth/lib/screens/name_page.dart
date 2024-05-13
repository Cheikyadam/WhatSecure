import 'package:flutter/material.dart';
import 'package:phone_auth/controllers/user_api/user_api.dart';
import 'package:phone_auth/encryption/encryption.dart';
import 'package:phone_auth/models/user_model.dart';
import 'package:phone_auth/screens/home.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';

class NamePage extends StatefulWidget {
  const NamePage({super.key, required this.phone});
  final String phone;
  @override
  State<NamePage> createState() => _NamePageState();
}

class _NamePageState extends State<NamePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(children: [
        const SizedBox(
          height: 20,
        ),
        Form(
          key: _formKey,
          child: TextFormField(
            controller: _nameController,
            decoration: InputDecoration(
                labelText: 'Enter your name (optional)',
                labelStyle: const TextStyle(fontSize: 20),
                //fillColor: Colors.white,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(32))),
            validator: (value) {
              if (value!.isEmpty) {
                return "Enter a valid name";
              }
              return null;
            },
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  final publiKey = await Encryption.keyPairGeneration();
                  final newUser = User(
                      id: widget.phone.toString(),
                      name: _nameController.text,
                      publicKey: publiKey);
                  await Api.addUser(newUser.toMap());
                  GetStorage().writeIfNull('connected', true);

                  Get.off(() => (const HomePage()));
                  /*Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HomePage()));*/
                }
              },
              child: const Text('Add your name'),
            ))
      ]),
      floatingActionButton: TextButton(
          onPressed: () async {
            final publiKey = await Encryption.keyPairGeneration();
            final newUser = User(
                id: widget.phone.toString(),
                name: _nameController.text,
                publicKey: publiKey);
            await Api.addUser(newUser.toMap());
            GetStorage().writeIfNull('connected', true);

            Get.off(() => (const HomePage()));
            /* Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const HomePage()));*/
          },
          child: const Text(
            'Skip',
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          )),
    );
  }
}
