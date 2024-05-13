import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ConstantsService {
  String? publicKey;
  String? privateKey;

  Future<void> initConstants() async {
    AndroidOptions getAndroidOptions() => const AndroidOptions(
          encryptedSharedPreferences: true,
        );
    final storage = FlutterSecureStorage(aOptions: getAndroidOptions());

    privateKey = await storage.read(key: 'privateKey');
    publicKey = await storage.read(key: 'publicKey');
  }
}
