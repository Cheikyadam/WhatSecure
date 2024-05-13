import "package:pointycastle/export.dart";
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:rsa_encrypt/rsa_encrypt.dart';
import 'package:pointycastle/api.dart' as crypto;

class Encryption {
  static Future<String> keyPairGeneration() async {
    Future<crypto.AsymmetricKeyPair<crypto.PublicKey, crypto.PrivateKey>>
        getKeyPair() {
      var helper = RsaKeyHelper();

      return helper.computeRSAKeyPair(helper.getSecureRandom());
    }

    Future<crypto.AsymmetricKeyPair> futureKeyPair;
    crypto.AsymmetricKeyPair keyPair;
    futureKeyPair = getKeyPair();

    keyPair = await futureKeyPair;

    final publicKey = keyPair.publicKey as RSAPublicKey;
    final privateKey = keyPair.privateKey as RSAPrivateKey;

    var helper = RsaKeyHelper();

    final private = helper.encodePrivateKeyToPemPKCS1(privateKey);
    final public = helper.encodePublicKeyToPemPKCS1(publicKey);
    final key = Hive.generateSecureKey();

    AndroidOptions getAndroidOptions() => const AndroidOptions(
          encryptedSharedPreferences: true,
        );
    final storage = FlutterSecureStorage(aOptions: getAndroidOptions());

    await storage.write(key: 'privateKey', value: private);
    await storage.write(key: 'hiveKey', value: key.toString());
    await storage.write(key: 'publicKey', value: public);
    // print("PRIVATE:${private}");

    //print("KEY HIVE:$key");

    //print("PUBLIC KEY: ${public}");
    return public;
  }

  static String encryptMessage(
      {required String message, required String publicKey}) {
    var helper = RsaKeyHelper();

    RSAPublicKey public = helper.parsePublicKeyFromPem(publicKey);
    return encrypt(message, public);
  }

  static String decryptMessage(
      {required String encodedMessage, required privateKey}) {
    var helper = RsaKeyHelper();
    RSAPrivateKey private = helper.parsePrivateKeyFromPem(privateKey);

    return decrypt(encodedMessage, private);
  }
}

/*Future<void> myfunction() async {
  Future<crypto.AsymmetricKeyPair<crypto.PublicKey, crypto.PrivateKey>>
      getKeyPair() {
    var helper = RsaKeyHelper();

    return helper.computeRSAKeyPair(helper.getSecureRandom());
  }

  Future<crypto.AsymmetricKeyPair> futureKeyPair;
  crypto.AsymmetricKeyPair keyPair;
  futureKeyPair = getKeyPair();

  //crypto.PublicKey publicKey = keyPair.publicKey;
  keyPair = await futureKeyPair;

  //String privateKey = encodePrivateKeyToPemPKCS1(keyPair.privateKey);

  String plaintext = "Hello world";

  final publicKey = keyPair.publicKey as RSAPublicKey;
  final privateKey = keyPair.privateKey as RSAPrivateKey;

  String encrypted = encrypt(plaintext, publicKey);

  String decr = decrypt(encrypted, privateKey);

  print("DECRYPT:        $decr");

  var helper = RsaKeyHelper();

  String lPrivate = helper.encodePrivateKeyToPemPKCS1(privateKey);
  print("PrivateKey:   $lPrivate");

  String lPublic = helper.encodePublicKeyToPemPKCS1(publicKey);
  print("PublicKey:     $lPublic");

  RSAPrivateKey newprivate = helper.parsePrivateKeyFromPem(lPrivate);

  String newdecr = decrypt(encrypted, newprivate);

  print("NEW TEST:  $newdecr");
}*/
