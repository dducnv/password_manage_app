import 'dart:convert';

import 'package:encrypt/encrypt.dart';

class EncryptData {
  static final instance = EncryptData._internal();

  EncryptData._internal();

  String encryptFernet({
    required String value,
    required String key,
  }) {
    if (key.isEmpty || value.isEmpty) {
      return "";
    }
    var keyFromUtf8 = Key.fromUtf8(key);
    final b64key =
        Key.fromUtf8(base64Url.encode(keyFromUtf8.bytes).substring(0, 32));
    final fernet = Fernet(b64key);
    final encrypter = Encrypter(fernet);
    final encrypted = encrypter.encrypt(value);
    return encrypted.base64;
  }

  String decryptFernet({required String value, required String key}) {
    var keyFromUtf8 = Key.fromUtf8(key);
    final b64key =
        Key.fromUtf8(base64Url.encode(keyFromUtf8.bytes).substring(0, 32));
    final fernet = Fernet(b64key);
    final encrypter = Encrypter(fernet);
    final decrypted = encrypter.decrypt(Encrypted.fromBase64(value));
    return decrypted;
  }

  String rsaEncrypt({required String value, required String key}) {
    return "";
  }

  String rsaDecrypt({required String codeBase64, required String key}) {
    return "";
  }
}

class HMAC {}
