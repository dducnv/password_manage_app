import 'dart:convert';

import 'package:encrypt/encrypt.dart';

class EncryptData {
  final keyFix = Key.fromUtf8('2my32lengthsupersecretnooneknows1');
  String encryptFernet({
    required String value,
    required String key,
  }) {
    final b64key =
        Key.fromUtf8(base64Url.encode(keyFix.bytes).substring(0, 32));
    final fernet = Fernet(b64key);
    final encrypter = Encrypter(fernet);
    final encrypted = encrypter.encrypt(value);
    return encrypted.base64;
  }

  String decryptFernet({required String codeBase64, required String key}) {
    final b64key =
        Key.fromUtf8(base64Url.encode(keyFix.bytes).substring(0, 32));
    final fernet = Fernet(b64key);
    final encrypter = Encrypter(fernet);
    final decrypted = encrypter.decrypt(Encrypted.fromBase64(codeBase64));
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
