import 'package:flutter/material.dart';
import 'package:password_manage_app/core/core.dart';

extension WidgetExt on Widget {
  void showCustomDialog(BuildContext context, DialogContent dialogContent) {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text(dialogContent.title),
            content: Text(dialogContent.content),
            actions: dialogContent.buttons
                .asMap()
                .map((index, button) => MapEntry(
                    index,
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        dialogContent.buttonActions[index]();
                      },
                      child: Text(button),
                    )))
                .values
                .toList(),
          );
        });
  }

  void hideKeyBoard(BuildContext context) {
    final currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }

  Future<bool> onSavePinCode({required String pinCode}) async {
    try {
      String codeEncrypted = EncryptData.instance.encryptFernet(
        key: Env.pinCodeKeyEncrypt,
        value: pinCode,
      );

      await SecureStorage.instance
          .save(SecureStorageKeys.pinCode.name, codeEncrypted);
      return true;
    } catch (e) {
      customLogger(msg: e.toString(), typeLogger: TypeLogger.error);
    }
    return false;
  }

  Future<bool> verifyPinCode({
    required String pinCodeEntered,
  }) async {
    try {
      if (pinCodeEntered.isEmpty) {
        return false;
      }
      String? pinCodeEncrypted =
          await SecureStorage.instance.read(SecureStorageKeys.pinCode.name);
      if (pinCodeEncrypted == null) {
        return false;
      }
      String pinCode = EncryptData.instance.decryptFernet(
        key: Env.pinCodeKeyEncrypt,
        value: pinCodeEncrypted,
      );

      if (pinCode.isEmpty) {
        return false;
      }

      return pinCode == pinCodeEntered;
    } catch (e) {
      customLogger(msg: e.toString(), typeLogger: TypeLogger.error);
    }

    return false;
  }

  Future<bool> checkLocalAuth() async {
    String? enableLocalAuth = await SecureStorage.instance
        .read(SecureStorageKeys.isEnableLocalAuth.name);

    if (enableLocalAuth == "false") {
      return false;
    }

    bool canCheckBiometrics = await LocalAuthConfig.instance.canCheckBiometrics;
    if (!canCheckBiometrics) {
      return false;
    }

    bool isAvailableBiometrics = LocalAuthConfig.instance.isAvailableBiometrics;

    if (!isAvailableBiometrics) {
      return false;
    }

    bool authenticated = await LocalAuthConfig.instance.authenticate();

    return authenticated;
  }
}
