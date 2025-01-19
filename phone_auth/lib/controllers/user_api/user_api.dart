import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../const.dart';

class Api {
  static addUser(Map data) async {
    var response = await http.post(Url.adding,
        headers: Url.requestHeaders, body: jsonEncode(data));
    if (response.statusCode == 200) {
      // var result = response.body;
      return {'code': 200};
    } else {
      return {'code': response.statusCode, 'error': response};
    }
  }

  static allUsers() async {
    var response = await http.get(Url.fetching);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return response.toString();
    }
  }

  static updateUsername(Map data, String userId) async {
    var response = await http.put(Uri.parse("http://$ip:8080/name/$userId"),
        headers: Url.requestHeaders, body: jsonEncode(data));
    if (response.statusCode == 200) {
      return {'code': 200};
    } else {
      return {'code': response.statusCode, 'error': response};
    }
  }

  static updateUserPhone(Map data, String userId) async {
    var response = await http.put(Uri.parse("http://$ip:8080/phone/$userId"),
        headers: Url.requestHeaders, body: jsonEncode(data));
    if (response.statusCode == 200) {
      return {'code': 200};
    } else {
      return {'code': response.statusCode, 'error': response};
    }
  }

  static deleteUser(String userId) async {
    var response = await http.delete(Uri.parse("http://$ip:8080/users/$userId"),
        headers: Url.requestHeaders);
    if (response.statusCode == 200) {
      return {'code': 200};
    } else {
      return {'code': response.statusCode, 'error': response};
    }
  }
}
