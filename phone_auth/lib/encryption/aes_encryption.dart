import 'package:encrypt/encrypt.dart';

class AesEncryption {
  // Static variables to hold the base64 encoded key and iv
  static String? key;
  static String? iv;

  /// Encrypts a given file string using AES encryption
  /// Generates a new random key and IV for each encryption
  /// Returns the encrypted string in base64 format
  static String encryptFile(String fileString) {
    final myKey = Key.fromSecureRandom(32); // 256-bit key
    final myIv = IV.fromSecureRandom(16); // 128-bit IV
    final encrypter = Encrypter(AES(myKey));

    key = myKey.base64; // Store the key in base64 format
    iv = myIv.base64; // Store the IV in base64 format

    final encrypted = encrypter.encrypt(fileString, iv: myIv);
    return encrypted.base64;
  }

  /// Decrypts a given encrypted string using AES encryption
  /// Requires the base64 encoded key and IV used for encryption
  /// Returns the decrypted file string
  static String decryptFile(String encrypted, String key, String iv) {
    try {
      final myKey = Key.fromBase64(key);
      final myIv = IV.fromBase64(iv);
      final encrypter = Encrypter(AES(myKey));
      final myEncrypted = Encrypted.from64(encrypted);

      final decrypted = encrypter.decrypt(myEncrypted, iv: myIv);
      return decrypted;
    } catch (e) {
      // Handle decryption error
      throw Exception('Decryption failed: $e');
    }
  }
}
