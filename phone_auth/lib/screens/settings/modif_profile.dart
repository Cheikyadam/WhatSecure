import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:phone_auth/const.dart';
import 'package:path/path.dart' as path;
import 'package:phone_auth/controllers/get_controllers/settings_controller.dart';
import 'package:phone_auth/controllers/profile_image_api/profile_image_api.dart';

class Modifprofile extends StatefulWidget {
  const Modifprofile({super.key});

  @override
  State<Modifprofile> createState() => _ModifprofileState();
}

class _ModifprofileState extends State<Modifprofile> {
  late ImagePicker imagePicker;
  final settingsController = Get.find<SettingsController>();
  Color _color = Colors.white;

  @override
  void initState() {
    super.initState();
    imagePicker = ImagePicker();
  }

  _imgFromCamera() async {
    XFile? pickedFile = await imagePicker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      String fileExtension = path.extension(pickedFile.path);
      await ProfileImageApi.postImage(pickedFile.path, fileExtension);
      settingsController.changeImageUrl();
    }
  }

  _imgFromGallery() async {
    XFile? pickedFile =
        await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      String fileExtension = path.extension(pickedFile.path);
      await ProfileImageApi.postImage(pickedFile.path, fileExtension);
      settingsController.changeImageUrl();
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Photo de profile',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  width: screenWidth * 0.9,
                  height: screenWidth * 0.9,
                  padding: const EdgeInsets.all(1),
                  decoration: BoxDecoration(
                      color: _color,
                      border: Border.all(
                        color: const Color.fromARGB(255, 230, 230, 230),
                      )),
                  child: Obx(
                    () => Image.network(settingsController.imageUrl.value,
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
                        _color = Colors.white;

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
              const SizedBox(height: 25),
              Container(
                margin: const EdgeInsets.only(bottom: 50),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Card(
                          //color: Theme.of(context).scaffoldBackgroundColor,
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(200))),
                          child: InkWell(
                            onTap: () async {
                              await _imgFromGallery();
                              setState(() {});
                            },
                            child: SizedBox(
                              width: screenWidth / 2 - 70,
                              height: screenWidth / 2 - 70,
                              child: Icon(Icons.image,
                                  color: color1, size: screenWidth / 7),
                            ),
                          ),
                        ),
                        Card(
                          // color: Theme.of(context).scaffoldBackgroundColor,
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(200))),
                          child: InkWell(
                            onTap: () {
                              _imgFromCamera();
                            },
                            child: SizedBox(
                              width: screenWidth / 2 - 70,
                              height: screenWidth / 2 - 70,
                              child: Icon(Icons.camera_alt_rounded,
                                  color: color1, size: screenWidth / 7),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Card(
                      //color: Theme.of(context).scaffoldBackgroundColor,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(200))),
                      child: InkWell(
                        onTap: () async {
                          await ProfileImageApi.deleteImage();
                          settingsController.changeImageUrl();
                        },
                        child: Container(
                          padding: const EdgeInsets.all(22),
                          child: SizedBox(
                            width: screenWidth / 2 - 110,
                            height: screenWidth / 2 - 110,
                            child: Image.asset(
                              'assets/icons/poubelle.png',
                              color: color1,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
