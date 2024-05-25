import 'package:flutter/material.dart';
import 'package:password_manage_app/core/core.dart';
import 'package:password_manage_app/ui/base/base.dart';
import 'package:password_manage_app/ui/route/route.dart';

class SplashScreenViewModel extends BaseViewModel {
  final CategoryUseCase sqlCategoryUsecase;

  SplashScreenViewModel({required this.sqlCategoryUsecase});

  void init(BuildContext context) async {
    AppLanguageProvider appLanguage = AppLanguageProvider();
    await appLanguage.fetchLocale(context);
    await checkFistOpenApp();
  }

  // Future<void> seedPinCode() async {
  //   try {
  //     String codeEncrypted = EncryptData.instance.encryptFernet(
  //       key: Env.pinCodeKeyEncrypt,
  //       value: "020712",
  //     );

  //     await SecureStorage.instance
  //         .save(SecureStorageKeys.pinCode.name, codeEncrypted);
  //   } catch (e) {
  //     customLogger(msg: e.toString(), typeLogger: TypeLogger.error);
  //   }
  // }

  Future<void> checkFistOpenApp() async {
    await SecureStorage.instance
        .read(SecureStorageKeys.fistOpenApp.name)
        .then((value) async {
      if (value == null) {
        Future.delayed(const Duration(milliseconds: 1000), () async {
          await Navigator.of(
            GlobalKeys.appRootNavigatorKey.currentContext!,
          ).pushNamedAndRemoveUntil(RoutePaths.welcomeScreen, (route) => false);
        });
      } else {
        Future.delayed(const Duration(milliseconds: 1000), () async {
          await Navigator.of(
            GlobalKeys.appRootNavigatorKey.currentContext!,
          ).pushNamedAndRemoveUntil(RoutePaths.localAuthView, (route) => false);
        });
      }
    });
  }
}
