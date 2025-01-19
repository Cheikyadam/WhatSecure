import 'dart:convert';
import 'package:hive/hive.dart';

part 'recognition_model.g.dart';

@HiveType(typeId: 4)
class RecognitionModel extends HiveObject {
  @HiveField(0)
  String name;
  @HiveField(1)
  List<double> embeddings;
  RecognitionModel({
    required this.name,
    required this.embeddings,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> json = {};
    json['name'] = name;
    json['embeddings'] = embeddings;

    return json;
  }

  factory RecognitionModel.fromJson(Map<String, dynamic> json) {
    return RecognitionModel(name: json['name'], embeddings: json['embeddings']);
  }

  static List<RecognitionModel> userFromJsonString(String str) {
    List<RecognitionModel> all = List<RecognitionModel>.from(
        json.decode(str).map((e) => RecognitionModel.fromJson(e)));
    return all;
  }
}
