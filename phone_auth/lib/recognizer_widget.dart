import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image/image.dart' as img;
import 'package:phone_auth/machine_learning/painter.dart';
import 'package:phone_auth/machine_learning/recognizer.dart';
import 'package:phone_auth/models/recognition.dart';
import 'const.dart';
import 'package:phone_auth/machine_learning/img_converter.dart';

class FaceRecognizer extends StatefulWidget {
  final void Function(int? result) onRecongized;
  const FaceRecognizer({required this.onRecongized, Key? key})
      : super(key: key);

  @override
  State<FaceRecognizer> createState() => _FaceRecognizerState();
}

class _FaceRecognizerState extends State<FaceRecognizer>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  dynamic controller;
  bool isBusy = false;
  late Size size;
  late CameraDescription description = cameras[1];
  CameraLensDirection camDirec = CameraLensDirection.front;
  late List<Recognition> recognitions = [];

  // declare face detector
  late FaceDetector faceDetector;

  //declare face recognizer
  late Recognizer recognizer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initCameras();
    //initialize face detector
    var options = FaceDetectorOptions(
        performanceMode: FaceDetectorMode.fast, enableTracking: true);
    faceDetector = FaceDetector(options: options);
    // initialize face recognizer
    recognizer = Recognizer();
    // initialize camera footage
    initializeCamera();
  }

  _initCameras() async {
    cameras = await availableCameras();
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
    InputImage? inputImage =
        getInputImage(cameras, camDirec, controller, frame);
    //pass InputImage to face detection model and detect faces
    List<Face> faces = await faceDetector.processImage(inputImage!);

    if (mounted) {
      if (faces.length > 1) {
        widget.onRecongized.call(2);
        setState(() {
          isBusy = false;
        });
      } else {
        //perform face recognition on detected faces
        performFaceRecognition(faces);
      }
    }
  }

  img.Image? image;
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
      if (mounted) {
        print('distance:${recognition.distance}');
        if (recognition.distance > 0.75) {
          widget.onRecongized.call(3);
          recognition.name = "Unknown";
        } else {
          widget.onRecongized.call(1);
        }
        recognitions.add(recognition);
      }
    }
    if (mounted) {
      setState(() {
        isBusy = false;
        _scanResults = recognitions;
      });
    }
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
