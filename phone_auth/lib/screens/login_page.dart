import 'package:flutter/material.dart';
import 'package:phone_auth/controllers/auth_service.dart';

import 'package:get_storage/get_storage.dart';
import 'package:phone_auth/screens/name_page.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _formKey1 = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    GetStorage().writeIfNull('verified', false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Auth Page'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              const Center(
                child: Text(
                  'Welcome to WhatSecure',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              const Text(
                'To continue, enter your phone number',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 20,
              ),
              Form(
                key: _formKey,
                child: TextFormField(
                  keyboardType: TextInputType.phone,
                  controller: _phoneController,
                  decoration: InputDecoration(
                      prefixText: '+212 ',
                      labelText: 'Enter your phone number',
                      labelStyle: const TextStyle(fontSize: 20),
                      //fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32))),
                  validator: (value) {
                    if (value!.length != 9) {
                      return "Invalid phone number";
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
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      AuthService.sentOtp(
                          phone: _phoneController.text,
                          errorStep: () => ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text(
                                  "Error in sending OTP",
                                  style: TextStyle(color: Colors.white),
                                ),
                                backgroundColor: Colors.red,
                              )),
                          nextStep: () => showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    title: const Text('OTP Verification'),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text('Enter 6 digit OTP'),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Form(
                                          key: _formKey1,
                                          child: TextFormField(
                                            controller: _otpController,
                                            keyboardType: TextInputType.phone,
                                            decoration: InputDecoration(
                                                labelText: 'Enter OTP',
                                                labelStyle: const TextStyle(
                                                    fontSize: 20),
                                                //fillColor: Colors.white,
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            32))),
                                            validator: (value) {
                                              if (value!.length != 6) {
                                                return "Invalid OTP";
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
                                            if (_formKey1.currentState!
                                                .validate()) {
                                              AuthService.loginWithOtp(
                                                      otp: _otpController.text)
                                                  .then((value) {
                                                if (value == "Success") {
                                                  final box = GetStorage();
                                                  box.write('verified', true);
                                                  final phone =
                                                      _phoneController.text;
                                                  box.write(
                                                      "phone", "+212$phone");
                                                  Navigator.pop(context);
                                                  final phoneNumber =
                                                      _phoneController.text;
                                                  Navigator.pushReplacement(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              NamePage(
                                                                phone:
                                                                    '+212$phoneNumber',
                                                              )));
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
                                            'Submit',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20),
                                          ))
                                    ],
                                  )));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                  ),
                  child: const Text('Send OTP'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
