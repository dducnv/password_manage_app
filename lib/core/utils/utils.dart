import 'package:password_manage_app/core/core.dart';


export 'app_language_provider.dart';
export 'constants.dart';
export 'data_shared.dart';
export 'dialog_content.dart';
export 'encrypt_utils.dart';
export 'global_keys.dart';
export 'local_auth_config.dart';
export 'logger.dart';
export 'result.dart';
export 'secure_storage.dart';
export 'strings.dart';
export 'theme_provider.dart';
export 'type_text_field.dart';

typedef JsonToModelHandle<T> = T Function(Map<String, dynamic>);
typedef TypeToTypeHandle<X, Y> = Y Function(X);

T? tryCast<T>(dynamic x) {
  if (x == null) {
    return null;
  }
  try {
    return x as T;
  } catch (e) {
    customLogger(
        msg:
            "CastError when trying to cast $x to $T!. Type x is ${x.runtimeType}",
        typeLogger: TypeLogger.error);

    return null;
  }
}


String decodeInfo(String info) {
    String pinCode = EncryptData.instance.decryptFernet(
        key: Env.infoEncryptKey,
        value: info,
      );
  return pinCode;
}

String decodePassword(String password) {
    String pinCode = EncryptData.instance.decryptFernet(
        key: Env.passwordEncryptKey,
        value: password,
      );
  return pinCode;
}