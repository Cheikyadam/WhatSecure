import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:phone_auth/const.dart';

import 'package:phone_auth/controllers/get_controllers/keys_controller.dart';
import 'package:phone_auth/controllers/get_controllers/settings_controller.dart';

class ProfileImageApi {
  static Future<void> postImage(String? imagePath, String fileExtension) async {
    if (imagePath == null) {
      return;
    }

    // verifier la tache du fichier si trop gros le compresser
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('http://$ip:8080/image'),
    );

    String id = Get.find<KeyController>().phone.value;
    String newFileName = "$id$fileExtension";
    request.files.add(await http.MultipartFile.fromPath('image', imagePath,
        contentType: MediaType('image', 'jpeg'), filename: newFileName));
    var response = await request.send();

    if (response.statusCode == 200) {
    } else {}
  }

  static getImage(String url) async {
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return {'code': 200};
    } else {
      return {'code': response.statusCode};
    }
  }

  static deleteImage() async {
    var response = await http
        .delete(Uri.parse(Get.find<SettingsController>().imageUrl.value));
    if (response.statusCode == 200) {
      return {'code': 200};
    } else {
      return {'code': response.statusCode};
    }
  }
}
