import 'dart:convert';
import 'package:http/http.dart' as http;
//import 'package:phone_auth/models/user_model.dart';
import 'const.dart';

class Api {
  static addUser(Map data) async {
    var response = await http.post(Url.adding,
        headers: Url.requestHeaders, body: jsonEncode(data));
    if (response.statusCode == 200) {
      var result = response.body;

      return result;
    } else {
      return response.toString();
    }
  }

  static allUsers() async {
    var response = await http.get(Url.fetching);
    if (response.statusCode == 200) {
      //return User.userFromJsonString(response.body);
      return jsonDecode(response.body);
    } else {
      return response.toString();
    }
  }
}
