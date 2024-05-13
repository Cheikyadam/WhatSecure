import 'dart:convert';

class Base {
  DateTime? createdAt;
  DateTime? updatedAt;
  String? picture;

  Base() {
    createdAt = DateTime.now();
    updatedAt = DateTime.now();
    picture = "";
  }
  Map<String, dynamic> toMap() {
    Map<String, dynamic> userjson = {};
    userjson['createdAt'] = createdAt!.toIso8601String();
    userjson['updatedAt'] = updatedAt!.toIso8601String();
    userjson['picture'] = picture.toString();
    return userjson;
  }
}

class User extends Base {
  String id;
  String name;
  String publicKey;
  User({required this.id, required this.name, required this.publicKey});

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> userjson = super.toMap();
    userjson['id'] = id;
    userjson['name'] = name;
    userjson['publicKey'] = publicKey;
    return userjson;
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json['id'], name: json['name'], publicKey: json['publicKey']);
  }

  /*static List<User> userFromJsonString(String str) {
    List<User> allUsers = [];
    List<dynamic> usersjson = json.decode(str);
    for (int i = 0; i < usersjson.length; i++) {
      allUsers.add(User.fromJson(usersjson[i]));
    }
    return allUsers;
  }
}*/

  static List<User> userFromJsonString(String str) {
    List<User> allUsers =
        List<User>.from(json.decode(str).map((e) => User.fromJson(e)));
    return allUsers;
  }
}
