import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image/image.dart' as img;
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:phone_auth/const.dart';
import 'package:phone_auth/controllers/hive_controller/hive_helper.dart';
import 'package:phone_auth/machine_learning/img_converter.dart';
import 'package:phone_auth/machine_learning/painter.dart';
import 'package:phone_auth/machine_learning/recognizer.dart';
import 'package:phone_auth/models/recognition.dart';
import 'package:phone_auth/screens/my_new_home_page.dart';
import 'package:phone_auth/screens/settings/modif_profile.dart';

class Registration extends StatefulWidget {
  //final void Function(int? result) onRecongized;
  const Registration({Key? key}) : super(key: key);

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  dynamic controller;
  bool isBusy = false;
  late Size size;
  late CameraDescription description = cameras[1];
  CameraLensDirection camDirec = CameraLensDirection.front;
  late List<Recognition> recognitions = [];
  Color _color = Colors.white;
  bool _error = true;
  String _text = "Pas de face detectee";
  // declare face detector
  late FaceDetector faceDetector;
  int counter = 1;
  bool _finish = false;

  //declare face recognizer
  late Recognizer recognizer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    //initialize face detector
    var options = FaceDetectorOptions(
        performanceMode: FaceDetectorMode.fast, enableTracking: true);
    faceDetector = FaceDetector(options: options);
    // initialize face recognizer
    recognizer = Recognizer();
    // initialize camera footage
    RecognitionHelper.deleteAllFace();
    initializeCamera();
  }

  //code to initialize the camera feed
  initializeCamera() async {
    try {
      controller = CameraController(description, ResolutionPreset.high,
          imageFormatGroup: Platform.isAndroid
              ? ImageFormatGroup.nv21 // for Android
              : ImageFormatGroup.bgra8888,
          enableAudio: false); // for iOS);

      await controller.initialize().then((_) {
        if (!mounted) {
          return;
        }
        //  print('HUMMMMMMMMMMMMMMMM');
        setState(() {});
        controller.startImageStream((image) => {
              if (!isBusy)
                {isBusy = true, frame = image, doFaceDetectionOnFrame()}
            });
      });
    } catch (e) {
      // print("CameraException: $e");
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    //final CameraController? cameraController = controller;

    // App state changed before we got the chance to initialize.
    if (controller == null || !controller.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.detached) {
      controller?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      initializeCamera();
    }
  }

  //close all resources
  @override
  void dispose() {
    controller?.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  //face detection on a frame
  dynamic _scanResults;
  CameraImage? frame;
  doFaceDetectionOnFrame() async {
    //convert frame into InputImage format
    if (frame == null) {
      //print("frame is null");
    }
    InputImage? inputImage =
        getInputImage(cameras, camDirec, controller, frame);
    //pass InputImage to face detection model and detect faces
    List<Face> faces = await faceDetector.processImage(inputImage!);
    //perform face recognition on detected faces
    if (counter < 6) {
      if (faces.isEmpty) {
        setState(() {
          _error = true;
          _text = "Pas de face detectee";
          isBusy = false;
        });
      } else {
        if (faces.length > 1) {
          setState(() {
            _error = true;
            _color = Colors.red;
            _text = "Plus d'une face detectee";
            isBusy = false;
          });
        } else {
          _error = false;
          _color = Colors.white;
          _text = "Enregistrement en cours...";
          performFaceRecognition(faces);
        }
      }
    } else {
      setState(() {
        controller.stopImageStream();
        //_color = Colors.green;
        //_text = "Enregistrement termine, appuyer pour continuer";
        _finish = true;
      });
    }
  }

  img.Image? image;
  img.Image? originalImage;
  bool register = false;
  //perform Face Recognition
  performFaceRecognition(List<Face> faces) async {
    recognitions.clear();

    //convert CameraImage to Image and rotate it so that our frame will be in a portrait
    image = Platform.isIOS
        ? convertBGRA8888ToImage(frame!) as img.Image?
        : convertNV21(frame!);

    image = img.copyRotate(image!,
        angle: camDirec == CameraLensDirection.front ? 270 : 90);
    originalImage = image;
    for (Face face in faces) {
      Rect faceRect = face.boundingBox;
      //crop face
      img.Image croppedFace = img.copyCrop(image!,
          x: faceRect.left.toInt(),
          y: faceRect.top.toInt(),
          width: faceRect.width.toInt(),
          height: faceRect.height.toInt());

      //pass cropped face to face recognition model
      Recognition recognition = recognizer.recognize(croppedFace, faceRect);
      if (recognition.distance > 1.0) {
        recognition.name = "Unknown";
      }
      recognition.name = "Enregistrement...";
      recognition.distance = counter.toDouble();
      recognitions.add(recognition);
      //register face
      recognizer.registerFaceInDB(counter.toString(), recognition.embeddings);
      counter++;
    }
    await Future.delayed(const Duration(milliseconds: 90)).then((value) {
      if (mounted) {
        setState(() {
          isBusy = false;
          _scanResults = recognitions;
        });
      }
    });
  }

  Widget buildResult() {
    if (_scanResults == null ||
        controller == null ||
        !controller.value.isInitialized) {
      return const Center(child: Text('Camera is not initialized'));
    }
    final Size imageSize = Size(
      controller.value.previewSize!.height,
      controller.value.previewSize!.width,
    );
    CustomPainter painter =
        FaceDetectorPainter(imageSize, _scanResults, camDirec);
    return CustomPaint(
      painter: painter,
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> stackChildren = [];
    size = MediaQuery.of(context).size;
    if (controller != null) {
      //View for displaying the live camera footage
      stackChildren.add(
        Positioned(
          top: 0.0,
          left: 0.0,
          width: size.width,
          height: size.height,
          child: Container(
            child: (controller != null && controller.value.isInitialized)
                ? AspectRatio(
                    aspectRatio: controller.value.aspectRatio,
                    child: CameraPreview(controller),
                  )
                : Container(),
          ),
        ),
      );

      // View for displaying rectangles around detected aces
      stackChildren.add(
        Positioned(
            top: 0.0,
            left: 0.0,
            width: size.width,
            height: size.height,
            child: buildResult()),
      );
    }

    // View for displaying the bar to switch camera direction or for registering faces
    stackChildren.add(Positioned(
      top: size.height - 140,
      left: 0,
      width: size.width,
      height: 80,
      child: Card(
        margin: const EdgeInsets.only(left: 20, right: 20),
        color: _color,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () {
                      if (_finish) {
                        if (GetStorage().read('profilPictureIsSet') == null ||
                            GetStorage().read('profilPictureIsSet') == false) {
                          Get.offAll(() => const Modifprofile(
                                first: true,
                              ));
                        } else {
                          Get.offAll(() => const MyNewHomePage());
                        }
                      }
                    },
                    child: _error
                        ? Text(
                            _text,
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          )
                        : LoadingAnimationWidget.prograssiveDots(
                            color: Colors.green, size: 50),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ));
    if (_finish) {
      return Dialog.fullscreen(
        child: TextButton(
          onPressed: () {
            if (GetStorage().read('profilPictureIsSet') == null ||
                GetStorage().read('profilPictureIsSet') == false) {
              Get.offAll(() => const Modifprofile(
                    first: true,
                  ));
            } else {
              Get.offAll(() => const MyNewHomePage());
            }

            //Get.offAll(() => const MyNewHomePage());
          },
          child: const Center(
            child: Text(
              textAlign: TextAlign.center,
              'Face sauvegardee avec succes, cliquer sur l\'ecran pour continuer',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      );
    }
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Container(
            margin: const EdgeInsets.only(top: 0),
            color: Colors.black,
            child: Stack(
              children: stackChildren,
            )),
      ),
    );
  }
}

// class PrepareRegistrationPage extends StatefulWidget {
//   const PrepareRegistrationPage({super.key});

//   @override
//   State<PrepareRegistrationPage> createState() =>
//       _PrepareRegistrationPageState();
// }

// class _PrepareRegistrationPageState extends State<PrepareRegistrationPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Container(
//           alignment: Alignment.center,
//           child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
//             const Text('Pret pour l\'enregistrement?'),
//             TextButton(
//               onPressed: () {
//                 Get.to(() => const Registration());
//               },
//               child: const Text('Oui'),
//             ),
//           ]),
//         ),
//       ),
//     );
//   }
// }
