import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'package:face_camera/face_camera.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ml_vision/new_register.dart';
import 'package:ml_vision/register_page.dart';
import 'package:ml_vision/services/ml_service.dart';
import 'services/locator.dart';

void main() async {
  setupServices();
  WidgetsFlutterBinding.ensureInitialized();
  await FaceCamera.initialize();
  await GetStorage.init();
  runApp(const MaterialApp(home: Home()));
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 200.0,
            ),
            TextButton(
              onPressed: () {
                Navigator.push(context,
                    (MaterialPageRoute(builder: (context) => const MyApp())));
              },
              child: const Text(
                'MessagePage',
                style: TextStyle(fontSize: 25),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(context,
                    (MaterialPageRoute(builder: (context) => const MyApp2())));
              },
              child: const Text(
                'RegisterPage',
                style: TextStyle(fontSize: 25),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final MLService _mlService = locator<MLService>();
  Color _color = Colors.white;
  bool _autocapture = true;
  bool _processCompairing = false;
  bool _stop = false;
  Face? face;
  CameraImage? _cameraImage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      setState(() {
        _autocapture = false;
      });
      if (!_stop) {
        print("\nYOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO\n");
        setState(() {
          _stop = true;
        });
      }
    } else if (state == AppLifecycleState.resumed) {
      if (!_stop) {
        setState(() {
          _stop = false;
        });
      }
      setState(() {
        _autocapture = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('FaceCamera example app'),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RegistrationScreen()));
                },
                icon: const Icon(Icons.menu_sharp))
          ],
        ),
        body: Stack(children: [
          SmartFaceCamera(
            stop: _stop,
            onCameraSet: (CameraController? cameraController) {},
            imageResolution: ImageResolution.high,
            defaultFlashMode: CameraFlashMode.off,
            enableAudio: false,
            performanceMode: FaceDetectorMode.accurate,
            autoCapture: _autocapture,
            onImage: (cameraImage) {
              setState(() {
                _cameraImage = cameraImage;
              });
            },
            defaultCameraLens: CameraLens.front,
            onCapture: (File? image) async {
              if (_processCompairing) {
                if (face != null) {
                  if (GetStorage().read('userModel') != null) {
                    await _mlService.initialize();

                    //final CameraImage cameraImage =
                    //  await convertFileToCameraImage(image!);
                    //final myface = await processImage(image.path);

                    /* if (GetStorage().read('userModel') == null) {
                    print(
                        "++++++++++++++++++++++++++++TEST++++++++++++++++++++++++");
                    _mlService.setCurrentPrediction(_cameraImage!, face);
                    List predictedData = _mlService.predictedData;

                    GetStorage()
                        .writeIfNull('userModel', jsonEncode(predictedData));
                    _mlService.setPredictedData([]);
                  }*/

                    //GetStorage().erase();

                    print(
                        "\n\n\n+++++++++++++++++++++++++++${face!.boundingBox}+++++++++++++++++++\n\n\n");
                    _mlService.setCurrentPrediction(_cameraImage!, face);
                    final res = await _mlService.predict();

                    if (!res) {
                      setState(() {
                        _color = Colors.black;
                      });
                      // await Future.delayed(const Duration(seconds: 10));
                    } else {
                      setState(() {
                        _color = Colors.greenAccent;
                      });
                      //await Future.delayed(const Duration(seconds: 15));
                    }

                    setState(() {
                      face = null;
                    });
                  }
                }

                setState(() {
                  _processCompairing = false;
                  face = null;
                  _autocapture = true;
                });
              }
            },
            onFaceDetected: (List<Face>? faces) async {
              if (faces!.length >= 2) {
                for (final face in faces) {
                  String text = 'face: ${face.boundingBox}';
                  print('\n\n\n\n=============$text================\n\n\n\n');
                }
                setState(() {
                  _color = Colors.red;
                });
                await Future.delayed(const Duration(seconds: 2));
              } else {
                if (faces.length == 1) {
                  setState(() {
                    _color = Colors.blue;
                    _processCompairing = true;
                    _autocapture = false;
                    face = faces[0];
                  });
                  //  await Future.delayed(const Duration(seconds: 3));
                }
              }

              setState(() {
                _color = Colors.white;
              });
            },
          ),
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: _color,
            child: const Center(
                child: Text(
              'MESSAGES HERE',
              style: TextStyle(fontSize: 20),
            )),
          ),
        ]));
  }
}
