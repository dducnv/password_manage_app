import 'package:flutter/material.dart';
import 'package:password_manage_app/core/core.dart';
import 'package:password_manage_app/ui/base/base.dart';
import 'package:password_manage_app/ui/route/route.dart';

class RegisterViewModel extends BaseViewModel {
  PageController pageController = PageController();
  ValueNotifier<bool> confirmScreen = ValueNotifier<bool>(false);

  String pinCode = "";

  void changeScreen() {
    confirmScreen.value = !confirmScreen.value;
  }

  void setPin(String pin) {
    pinCode = pin;
    confirmScreen.value = true;
    pageController.nextPage(
        duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
  }

  Future<void> savePinCode() async {
    try {
      String codeEncrypted = EncryptData.instance.encryptFernet(
        key: Env.pinCodeKeyEncrypt,
        value: pinCode,
      );

      await SecureStorage.instance
          .save(SecureStorageKeys.pinCode.name, codeEncrypted);

     await SecureStorage.instance
          .save(SecureStorageKeys.fistOpenApp.name, "false");

      Navigator.of(GlobalKeys.appRootNavigatorKey.currentContext!)
          .pushNamedAndRemoveUntil(RoutePaths.homeRoute, (route) => false);
    } catch (e) {
      customLogger(msg: e.toString(), typeLogger: TypeLogger.error);
    }
  }
}
