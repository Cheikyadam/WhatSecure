import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phone_auth/controllers/get_controllers/keys_controller.dart';
import 'package:phone_auth/const.dart';
import 'package:phone_auth/controllers/get_controllers/settings_controller.dart';
import 'package:phone_auth/screens/message_page.dart';
//import 'package:phone_auth/screens/message_screen.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final contacts = Get.find<KeyController>();
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: kToolbarHeight * 0.5,
        ),
        body: Column(
          children: [
            const Center(
              child: Text(
                'Mes contacts',
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              height: 35,
              margin: const EdgeInsets.only(left: 12, right: 12, top: 12),
              decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 210, 210, 210),
                  border: Border.all(),
                  borderRadius: const BorderRadius.all(Radius.circular(12))),
              child: Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(
                        left: 25, top: 2, right: 50, bottom: 3),
                    child: Image.asset(
                      'assets/icons/search.png',
                      height: 20,
                    ),
                  ),
                  const Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                          hintText: 'Rechercher un contact',
                          border: InputBorder.none),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            InkWell(
              onTap: () {
                Get.find<KeyController>().refreshContact();
                Get.find<SettingsController>().changeTimestamp();
              },
              child: Container(
                padding: const EdgeInsets.all(2),
                margin: const EdgeInsets.only(bottom: 12),
                decoration: const BoxDecoration(
                    color: color2,
                    borderRadius: BorderRadius.all(Radius.circular(7))),
                child: Text('Rafraichir',
                    style: Theme.of(context).textTheme.bodySmall),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 15),
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                color: color1,
                border: Border(bottom: BorderSide(color: color1)),
              ),
            ),
            Expanded(
              child: Obx(
                () => ListView.builder(
                  shrinkWrap: true,
                  itemCount: contacts.allContact.length,
                  itemBuilder: (context, index) => ContactWidget(
                    id: contacts.allContact[index].userId,
                    displayName: contacts.allContact[index].displayName,
                    onTap: () {
                      Get.to(() => MessagesPage(
                            id: contacts.allContact[index].userId,
                            displayName: contacts.allContact[index].displayName,
                          ));
                    },
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}

class ContactWidget extends StatelessWidget {
  final String displayName;
  final VoidCallback onTap;
  final String id;
  const ContactWidget({
    super.key,
    required this.displayName,
    required this.onTap,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 10.0, top: 8.0),
      padding: const EdgeInsets.only(left: 8.0, top: 8.0, bottom: 8.0),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            const SizedBox(
              width: 15,
            ),
            Container(
              margin: const EdgeInsets.only(right: 15),
              child: IconProfilWidgetContact(
                  settingsController: Get.find<SettingsController>(), id: id),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(bottom: 15.0),
                decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide(color: color1))),
                child: Text(
                  displayName,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class IconProfilWidgetContact extends StatelessWidget {
  const IconProfilWidgetContact({
    super.key,
    required this.settingsController,
    required this.id,
  });

  final SettingsController settingsController;
  final String id;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Obx(
        () => Image.network(
          'http://$ip:8080/image/$id?timestamp=${settingsController.timestamp.value}',
          width: 50,
          height: 50,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            padding: const EdgeInsets.all(7),
            decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color.fromARGB(255, 230, 230, 230)),
            child: Image.asset(
              'assets/icons/profil.png',
              width: 40,
              height: 40,
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
