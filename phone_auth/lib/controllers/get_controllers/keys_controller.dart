import 'package:get/get.dart';
import 'package:phone_auth/controllers/constants/constant_service.dart';

class KeyController extends GetxController {
  RxString publicKey = "".obs;
  RxString privateKey = "".obs;

  @override
  void onInit() {
    super.onInit();
    _loadValue();
  }

  void _loadValue() async {
    final constantsService = ConstantsService();
    await constantsService.initConstants();
    publicKey = constantsService.publicKey!.obs;
    privateKey = constantsService.privateKey!.obs;
  }
}
