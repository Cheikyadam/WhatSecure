import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:phone_auth/controllers/constants/constant_service.dart';
import 'package:phone_auth/controllers/contact_api/contact_api.dart';
import 'package:phone_auth/models/user_contact.dart';

class KeyController extends GetxController {
  RxString publicKey = "".obs;
  RxString privateKey = "".obs;
  RxString phone = "".obs;
  RxString username = "".obs;
  RxList<AppContact> allContact = <AppContact>[].obs;
  RxBool inUnread = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadValue();
    // print('key');
    //print(allContact.length);
    // for (AppContact contact in allContact) {
    //   print(contact.userId);
    //}
  }

  void _loadValue() async {
    final constantsService = ConstantsService();
    await constantsService.initConstants();
    publicKey.value = constantsService.publicKey!;
    privateKey.value = constantsService.privateKey!;
    phone.value = GetStorage().read('phone');
    username.value = GetStorage().read('username');
    allContact.value = await UserContact.fetchContacts();
  }

  void changeInUnread() {
    if (inUnread.isFalse) {
      inUnread.value = true;
    } else {
      inUnread.value = false;
    }
  }

  String getDisplayName(String discussionId) {
    return UserContact.getDisplayname(
      allContact,
      discussionId,
    );
  }

  void refreshContact() async {
    allContact.value = await UserContact.fetchContacts();
  }

  AppContact? getContact(String contact) {
    for (AppContact current in allContact) {
      if (current.userId == contact) {
        return current;
      }
    }
    return null;
  }
}
