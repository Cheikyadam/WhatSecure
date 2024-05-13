import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phone_auth/controllers/contact_api/contact_api.dart';
import 'package:phone_auth/models/user_contact.dart';
import 'package:phone_auth/screens/home.dart';
import 'package:phone_auth/screens/message_screen.dart';
//import 'package:phone_auth/controllers/user_api/user_api.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacts'),
        leading: IconButton(
          onPressed: () {
            Get.off(() => const HomePage());
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        actions: [
          IconButton(
              onPressed: () async {
                // await UserContact.fetchContacts();
                //await Api.allUsers();
              },
              icon: const Icon(Icons.search))
        ],
      ),
      body: Center(
        child: FutureBuilder<List<AppContact>>(
          future: UserContact.fetchContacts(),
          builder:
              (BuildContext context, AsyncSnapshot<List<AppContact>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else {
              if (snapshot.hasError) {
                return Text('Une errerur est survenue ${snapshot.error}');
              } else {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) => Container(
                    // alignment: Alignment.centerLeft,
                    margin: const EdgeInsets.only(left: 10, right: 10),
                    child: Center(
                      child: OutlinedButton(
                        onPressed: () {
                          Get.off(() => (Message(
                                displayname: snapshot.data![index].displayName,
                                id: snapshot.data![index].userId,
                              )));
                          /*Chat(
                                      chatId: snapshot.data![index].phones.first
                                          .normalizedNumber,
                                      userId: ""));*/
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Colors.white),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        child: Column(children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Row(children: [
                            const Icon(Icons.person),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(snapshot.data![index].displayName)
                          ]),
                        ]),
                      ),
                    ),
                  ),
                );
              }
            }
          },
        ),
      ),
    );
  }
}
