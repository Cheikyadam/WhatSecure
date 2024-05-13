import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:phone_auth/controllers/hive_controller/hive_helper.dart';
import 'package:phone_auth/controllers/user_api/user_api.dart';
import 'package:phone_auth/models/user_contact.dart';

class UserContact {
  static List<Contact>? _contacts;

  static Future<List<AppContact>> fetchContacts() async {
    print("HERE");
    if (!await FlutterContacts.requestPermission(readonly: true)) {
      print("WHTAT");
      return [];
    } else {
      print("OKAY");
      _contacts = await FlutterContacts.getContacts(withProperties: true);

      List<dynamic> allUsers = await Api.allUsers();
      List<String> allUsersId = List<String>.from(allUsers.map((e) => e['id']));
      List<Contact> contactMatched = [];
      for (int i = 0; i < _contacts!.length; i++) {
        String id = _contacts![i].phones.first.normalizedNumber;

        if (allUsersId.contains(id)) {
          String publicKey = getPublicKey(allUsers, id);
          AppContactHelper.addContact(AppContact(
              userId: id,
              displayName: _contacts![i].displayName,
              publicKey: publicKey));
          print(id);
          contactMatched.add(_contacts![i]);
        }
      }
      //print(contactMatched);
      // return contactMatched;
      print('hum');
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
