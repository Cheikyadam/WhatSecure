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
}
