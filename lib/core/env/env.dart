import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
  @EnviedField(varName: 'PIN_CODE_ENCRYPT_KEY', obfuscate: true)
  static final String pinCodeKeyEncrypt = _Env.pinCodeKeyEncrypt;

  @EnviedField(varName: 'INFO_ENCRYPT_KEY', obfuscate: true)
  static final String infoEncryptKey = _Env.infoEncryptKey;

  @EnviedField(varName: 'PASSWORD_ENCRYPT_KEY', obfuscate: true)
  static final String passwordEncryptKey = _Env.passwordEncryptKey;
}
