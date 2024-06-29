import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phone_auth/const.dart';
import 'package:phone_auth/controllers/get_controllers/settings_controller.dart';

class ContactProfilPage extends StatelessWidget {
  final String id;
  final String displayName;
  const ContactProfilPage(
      {super.key, required this.id, required this.displayName});

  @override
  Widget build(BuildContext context) {
    Color color = Colors.white;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text(displayName),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // const SizedBox(
                //   height: 25.0,
                // ),
                Container(
                    alignment: Alignment.center,
                    width: screenWidth * 0.9,
                    height: screenHeight * 0.7,
                    padding: const EdgeInsets.all(1),
                    decoration: BoxDecoration(
                        color: color,
                        border: Border.all(
                          color: const Color.fromARGB(255, 230, 230, 230),
                        )),
                    child: Obx(
                      () => Image.network(
                          'http://$ip:8080/image/$id?timestamp=${Get.find<SettingsController>().timestamp.value}',
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Text(
                            'Pas de photo de profile',
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        );
                      }, loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) {
                          color = Colors.white;

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
                      }),
                    )),
              ]),
        ),
      ),
    );
  }
}
