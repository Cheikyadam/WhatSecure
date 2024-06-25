import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';
import 'package:image/image.dart' as img;
import 'package:phone_auth/controllers/hive_controller/hive_helper.dart';
import 'package:phone_auth/models/recognition.dart';
import 'package:phone_auth/models/recognition_model.dart';

import 'package:tflite_flutter/tflite_flutter.dart';

class Recognizer {
  late Interpreter interpreter;
  late InterpreterOptions _interpreterOptions;
  // ignore: constant_identifier_names
  static const int WIDTH = 112;
  // ignore: constant_identifier_names
  static const int HEIGHT = 112;
  // final dbHelper = DatabaseHelper();
  List<RecognitionModel> all = [];
  //Map<String, RecognitionModel> registered = Map();
  // @override
  String get modelName => 'assets/mobile_face_net.tflite';

  Recognizer({int? numThreads}) {
    _interpreterOptions = InterpreterOptions();

    if (numThreads != null) {
      _interpreterOptions.threads = numThreads;
    }
    loadModel();
    initDB();
  }

  initDB() async {
    all = await RecognitionHelper.getAllRecognition();
  }

  void registerFaceInDB(String name, List<double> embedding) async {
    RecognitionModel recognitionModel =
        RecognitionModel(name: name, embeddings: embedding);

    await RecognitionHelper.addRecognition(recognitionModel);
    await initDB();
  }

  Future<void> loadModel() async {
    try {
      interpreter = await Interpreter.fromAsset(modelName);
    } catch (e) {
      //  print('Unable to create interpreter, Caught Exception: ${e.toString()}');
    }
  }

  List<dynamic> imageToArray(img.Image inputImage) {
    img.Image resizedImage =
        img.copyResize(inputImage, width: WIDTH, height: HEIGHT);
    List<double> flattenedList = resizedImage.data!
        .expand((channel) => [channel.r, channel.g, channel.b])
        .map((value) => value.toDouble())
        .toList();
    Float32List float32Array = Float32List.fromList(flattenedList);
    int channels = 3;
    int height = HEIGHT;
    int width = WIDTH;
    Float32List reshapedArray = Float32List(1 * height * width * channels);
    for (int c = 0; c < channels; c++) {
      for (int h = 0; h < height; h++) {
        for (int w = 0; w < width; w++) {
          int index = c * height * width + h * width + w;
          reshapedArray[index] =
              (float32Array[c * height * width + h * width + w] - 127.5) /
                  127.5;
        }
      }
    }
    return reshapedArray.reshape([1, 112, 112, 3]);
  }

  Recognition recognize(img.Image image, Rect location) {
    // crop face from image resize it and convert it to float array
    var input = imageToArray(image);
    // print(input.shape.toString());

    // output array
    List output = List.filled(1 * 192, 0).reshape([1, 192]);

    // performs inference
    // final runs = DateTime.now().millisecondsSinceEpoch;
    interpreter.run(input, output);
    //  final run = DateTime.now().millisecondsSinceEpoch - runs;
    //print('Time to run inference: $run ms$output');

    // convert dynamic list to double list
    List<double> outputArray = output.first.cast<double>();

    //looks for the nearest embeeding in the database and returns the pair
    Pair pair = findNearest(outputArray);
    //print("distance= ${pair.distance}");

    return Recognition(pair.name, location, outputArray, pair.distance);
  }

  //  looks for the nearest embeeding in the database and returns the pair which contain information of registered face with which face is most similar
  findNearest(List<double> emb) {
    Pair pair = Pair("Unknown", -5);
    //print("ALL: ${all[1].embeddings}\n\n");
    for (var item in all) {
      final String name = item.name;
      List<double> knownEmb = item.embeddings;
      double distance = 0;
      for (int i = 0; i < emb.length; i++) {
        double diff = emb[i] - knownEmb[i];
        distance += diff * diff;
      }
      distance = sqrt(distance);
      if (pair.distance == -5 || distance < pair.distance) {
        pair.distance = distance;
        pair.name = name;
      }
    }
    return pair;
  }

  void close() {
    interpreter.close();
  }
}

class Pair {
  String name;
  double distance;
  Pair(this.name, this.distance);
}
