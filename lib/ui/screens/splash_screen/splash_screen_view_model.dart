import 'package:flutter/material.dart';
import 'package:password_manage_app/core/core.dart';
import 'package:password_manage_app/ui/base/base.dart';
import 'package:password_manage_app/ui/route/route.dart';

class SplashScreenViewModel extends BaseViewModel {
  final CategoryUseCase sqlCategoryUsecase;

  SplashScreenViewModel({required this.sqlCategoryUsecase});

  void init() async {
    await SecureStorage.instance
        .read(SecureStorageKeys.pinCode.name)
        .then((value) async {
      if (value == null) {
        await seedPinCode();
      }
    });
    Future.delayed(const Duration(milliseconds: 1000), () async {
      await Navigator.pushReplacementNamed(
          GlobalKeys.appRootNavigatorKey.currentContext!,
          RoutePaths.localAuthView);
    });
  }

  Future<void> seedPinCode() async {
    try {
      await SecureStorage.instance
          .save(SecureStorageKeys.isEnableLocalAuth.name, "true");

      String codeEncrypted = EncryptData.instance.encryptFernet(
        key: Env.pinCodeKeyEncrypt,
        value: "020712",
      );

      await SecureStorage.instance
          .save(SecureStorageKeys.pinCode.name, codeEncrypted);
    } catch (e) {
      customLogger(msg: e.toString(), typeLogger: TypeLogger.error);
    }
  }
}
