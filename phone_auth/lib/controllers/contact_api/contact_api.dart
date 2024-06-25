import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:phone_auth/controllers/hive_controller/hive_helper.dart';
import 'package:phone_auth/controllers/user_api/user_api.dart';
import 'package:phone_auth/models/user_contact.dart';

class UserContact {
  static List<Contact>? _contacts;

  static Future<List<AppContact>> fetchContacts() async {
    if (!await FlutterContacts.requestPermission(readonly: true)) {
      return [];
    } else {
      _contacts = await FlutterContacts.getContacts(withProperties: true);

      List<dynamic> allUsers = await Api.allUsers();
      List<String> allUsersId = List<String>.from(allUsers.map((e) => e['id']));
      if (_contacts!.isEmpty) {
        return [];
      }

      await AppContactHelper.deleteAppContact();
      for (int i = 0; i < _contacts!.length; i++) {
        if (_contacts![i].phones.isNotEmpty) {
          String id = _contacts![i].phones.first.normalizedNumber;
          //print(id);
          //if (id.contains("+212")) {}
          if (allUsersId.contains(id)) {
            //print(i);
            String publicKey = getPublicKey(allUsers, id);
            AppContactHelper.addContact(AppContact(
                userId: id,
                displayName: _contacts![i].displayName,
                publicKey: publicKey));
          }
        }
      }
      return AppContactHelper.getAllContact();
    }
  }

  static String getPublicKey(List<dynamic> users, String id) {
    for (int i = 0; i < users.length; i++) {
      if (users[i]['id'] == id) {
        return users[i]['publicKey'];
      }
    }
    return "";
  }

  static String getDisplayname(List<AppContact> allCont, String phone) {
    for (int i = 0; i < allCont.length; i++) {
      if (allCont[i].userId == phone) {
        return allCont[i].displayName;
      }
    }
    return phone;
  }

  static String getPublic(List<AppContact> allCont, String phone) {
    for (int i = 0; i < allCont.length; i++) {
      if (allCont[i].userId == phone) {
        return allCont[i].publicKey;
      }
    }
    return "";
  }
}
