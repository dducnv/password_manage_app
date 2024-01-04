import 'package:password_manage_app/core/utils/logger.dart';

export 'global_keys.dart';
export 'app_language_provider.dart';
export 'secure_storage.dart';
export 'theme_provider.dart';
export 'type_text_field.dart';
export 'strings.dart';
export 'result.dart';

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
