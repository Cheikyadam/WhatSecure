import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ml_vision/detector_helper.dart';
import 'services/locator.dart';
import 'services/ml_service.dart';
import 'package:camera/camera.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _HomePageState();
}

class _HomePageState extends State<RegistrationScreen> {
  late ImagePicker imagePicker;
  File? _image;

  final MLService _mlService = locator<MLService>();

  @override
  void initState() {
    super.initState();
    imagePicker = ImagePicker();
  }

  _imgFromCamera() async {
    XFile? pickedFile = await imagePicker.pickImage(
        source: ImageSource.camera, preferredCameraDevice: CameraDevice.front);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  _imgFromGallery() async {
    XFile? pickedFile =
        await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    //double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Face Registration'),
      ),
      resizeToAvoidBottomInset: false,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _image != null
              ? Container(
                  margin: const EdgeInsets.only(top: 15),
                  width: screenWidth - 50,
                  height: screenWidth - 50,
                  child: Image.file(_image!),
                )
              : Container(
                  margin: const EdgeInsets.only(top: 50),
                  child: const Center(
                    child: Icon(
                      Icons.image,
                      size: 250,
                    ),
                  )),
          Container(
              //height: 10,
              ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Card(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(200))),
                child: InkWell(
                  onTap: () {
                    _imgFromGallery();
                  },
                  child: SizedBox(
                    width: screenWidth / 2 - 70,
                    height: screenWidth / 2 - 70,
                    child: Icon(Icons.image,
                        color: Colors.blue, size: screenWidth / 7),
                  ),
                ),
              ),
              Card(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(200))),
                child: InkWell(
                  onTap: () {
                    _imgFromCamera();
                  },
                  child: SizedBox(
                    width: screenWidth / 2 - 70,
                    height: screenWidth / 2 - 70,
                    child: const Image(image: AssetImage('assets/logo.png')),
                    //Icon(Icons.camera,
                    //color: Colors.blue, size: screenWidth / 7),
                  ),
                ),
              )
            ],
          ),
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(25),
            child: ElevatedButton(
                onPressed: () async {
                  final faces = await processImage(_image!.path);

                  // print(faces);
                  for (final face in faces) {
                    String text = 'face: ${face.boundingBox}';
                    print('\n\n=============$text================\n\n');
                  }
                  await _mlService.initialize();
                  final CameraImage cameraImage =
                      await convertFileToCameraImage(_image!);
                  _mlService.setCurrentPrediction(cameraImage, faces[0]);
                  List predictedData = _mlService.predictedData;
                  GetStorage().write('userModel', jsonEncode(predictedData));
                },
                style: ElevatedButton.styleFrom(),
                child: const Text("SAVE", style: TextStyle(fontSize: 18))),
          )
        ],
      ),
    );
  }
}
