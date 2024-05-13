import 'dart:convert';
import 'dart:io';
import 'package:get_storage/get_storage.dart';
import 'package:ml_vision/main.dart';

import 'services/locator.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'package:face_camera/face_camera.dart';
import 'package:ml_vision/services/ml_service.dart';

class MyApp2 extends StatefulWidget {
  const MyApp2({Key? key}) : super(key: key);

  @override
  State<MyApp2> createState() => _MyApp2State();
}

class _MyApp2State extends State<MyApp2>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  Face? _face;
  bool _autocapture = true;
  bool _stop = false;
  // CameraController? _cameraController;
  final MLService _mlService = locator<MLService>();
  CameraImage? _cameraImage;
  final snackBar = const SnackBar(
    content: Text("Plus d'une face detectée"),
    backgroundColor: Colors.red,
    duration: Duration(seconds: 2),
  );

  final List<List> _data = [];
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      if (!_stop) {
        setState(() {
          _stop = true;
        });
      }
    } else if (state == AppLifecycleState.resumed) {
      if (!_stop) {
        setState(() {
          _stop = true;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              if (!_stop) {
                setState(() {
                  _stop = true;
                });
              }
              Navigator.pushReplacement(context,
                  (MaterialPageRoute(builder: (context) => const Home())));
            },
            icon: const Icon(Icons.arrow_back),
          ),
          title: const Text('FaceCamera example app'),
        ),
        bottomNavigationBar: _autocapture
            ? TextButton(
                onPressed: () {},
                child: const Text(
                  'Sauvegarde en cours...',
                  style: TextStyle(fontSize: 20),
                ),
              )
            : TextButton(
                onPressed: () {
                  if (!_stop) {
                    setState(() {
                      _stop = true;
                    });
                  }
                  Navigator.pushReplacement(context,
                      (MaterialPageRoute(builder: (context) => const Home())));
                },
                child: const Text(
                  'Sauvegarde terminé...',
                  style: TextStyle(fontSize: 20, color: Colors.green),
                )),
        body: SmartFaceCamera(
          onCameraSet: (CameraController? cameraController) {},
          onImage: (cameraImage) {
            setState(() {
              _cameraImage = cameraImage;
            });
          },
          stop: _stop,
          enableAudio: false,
          autoDisableCaptureControl: true,
          imageResolution: ImageResolution.high,
          performanceMode: FaceDetectorMode.accurate,
          autoCapture: _autocapture,
          defaultCameraLens: CameraLens.front,
          onCapture: (File? image) async {
            if (_data.length < 5) {
              print("\n\nDATA: ${_data.length}==========================\n\n");
              if (_face != null) {
                await _mlService.initialize();

                _mlService.setCurrentPrediction(_cameraImage!, _face);
                List predictedData = _mlService.predictedData;
                _data.add(predictedData);
                _mlService.setPredictedData([]);
              }
            } else {
              print("\n\nDATA: ${_data.length}==========================\n\n");

              GetStorage().write('userModel', jsonEncode(_data));
              setState(() {
                _autocapture = false;
                _stop = true;
              });
            }
            setState(() {
              _face = null;
            });
          },
          onFaceDetected: (List<Face>? faces) {
            if (faces != null) {
              if (faces.length > 1) {
                setState(() {
                  _face = null;
                });

                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              } else {
                setState(() {
                  _face = faces[0];
                });
              }
            }
            //Do something
          },
        ));
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
