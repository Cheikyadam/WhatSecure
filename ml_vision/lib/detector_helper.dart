import 'dart:io';
import 'package:flutter/services.dart';
import 'package:camera/camera.dart';
import 'package:image/image.dart' as img;
import 'package:face_camera/face_camera.dart';
import 'package:camera_platform_interface/camera_platform_interface.dart';

Future<List<Face>> processImage(String path) async {
  final inputImage = InputImage.fromFilePath(path);
  final FaceDetector faceDetector = FaceDetector(
    options: FaceDetectorOptions(
        //enableContours: true,
        enableLandmarks: true,
        enableTracking: true,
        performanceMode: FaceDetectorMode.accurate),
  );

  final faces = await faceDetector.processImage(inputImage);
  if (inputImage.metadata?.size != null &&
      inputImage.metadata?.rotation != null) {
    print("No reconized face");
    return [];
    //final painter = FaceDetectorPainter(faces, inputImage.metadata!.size,
    //  inputImage.metadata!.rotation, CameraLensDirection.front);
    //print(painter);
  } else {
    // print(faces);
    // for (final face in faces) {
    //   String text = 'face: ${face.boundingBox}\n\n';
    //   print('=============$text================');
    // }
    return faces;
  }
}

Future<CameraImage> convertFileToCameraImage(File file) async {
  //print("==========================CALLED====================");
  String path = file.path;
  final File imageFile = File(path);
  final img.Image? image = img.decodeImage(imageFile.readAsBytesSync());
  final Uint8List bytes = image!.getBytes(format: img.Format.rgba);
  final imageWidth = image.width;
  final imageHeight = image.height;
  final depthPerPixelBits = await getImageColorDepth(path);
  // print("===================$depthPerPixelBits=================");
  final bytesPerPixel = depthPerPixelBits ~/ 8;
  final bytesPerRow = imageWidth * bytesPerPixel;

  final CameraImageData data = CameraImageData(
    format: const CameraImageFormat(ImageFormatGroup.bgra8888, raw: true),
    planes: [
      CameraImagePlane(
          bytes: bytes,
          bytesPerRow: bytesPerRow,
          bytesPerPixel: bytesPerPixel,
          width: imageWidth,
          height: imageHeight)
    ],
    height: imageHeight,
    width: imageWidth,
  );
  //print("++++++++++++++++++++++++++FINISHED========================");
  return CameraImage.fromPlatformInterface(data);
}

Future<int> getImageColorDepth(String imagePath) async {
  const MethodChannel channel = MethodChannel('image_depth_channel');
  try {
    final int? colorDepth = await channel
        .invokeMethod<int>('getImageColorDepth', {'imagePath': imagePath});
    return colorDepth!;
  } on PlatformException catch (e) {
    print(
        "Erreur lors de la récupération de la profondeur de couleur de l'image: '${e.message}'.");
    return -1;
  }
}

/*Future<CameraImage> convertImageToCameraImage(XFile imageFile) async {
  // Chargez l'image depuis le fichier
  final imageBytes = await imageFile.readAsBytes();

  // Créez une instance de CameraImage
  final CameraImageData data = CameraImageData(
      format: CameraImageFormat(ImageFormatGroup.yuv420,
          raw: android.graphics.ImageFormat),
          width: imageFile.w);
  final cameraImage = CameraImage.fromPlatformInterface(
    planes: [
      // Créez un plan d'image avec les données de l'image
      CameraImagePlane(
        bytes: Uint8List.fromList(imageBytes),
        width: imageFile.width,
        height: imageFile.height,
      ),
    ],
    formatGroup: ImageFormatGroup.yuv420,
    // Vous pouvez également spécifier d'autres informations ici
  );

  return cameraImage;
}

// Utilisation :
//final imageFile = await getImageFromPicker(); // Remplacez par votre méthode pour obtenir l'image
//final cameraImage = await convertImageToCameraImage(imageFile);

// Maintenant, vous pouvez utiliser l'instance de CameraImage comme nécessaire !
*/
