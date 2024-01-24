// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:password_manage_app/core/core.dart';
import 'package:password_manage_app/ui/base/base.dart';
import 'package:password_manage_app/ui/route/route.dart';
import 'package:password_manage_app/ui/screens/screen.dart';
import 'package:password_manage_app/ui/widgets/widgets.dart';
import 'package:privacy_screen/privacy_screen.dart';

class LocalAuthView extends StatelessWidget {
  const LocalAuthView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<LocalAuthViewModel>(
        builder: (context, viewModel, child) {
          return PinCodeWidget(
            maxPinLength: 6,
            minPinLength: 6,
            onPressColorAnimation:
                MediaQuery.of(context).platformBrightness == Brightness.light
                    ? Colors.black
                    : Colors.white,
            centerBottomWidget: LocalAuthConfig.instance.isAvailableBiometrics
                ? IconButton(
                    iconSize: 50,
                    onPressed: () async {
                      bool isAuth = await checkLocalAuth();

                      if (isAuth) {
                        PrivacyScreen.instance.unlock();
                        await Navigator.of(context)
                            .pushReplacementNamed(RoutePaths.homeRoute);
                      }
                    },
                    icon: const Icon(
                      Icons.fingerprint,
                      size: 50,
                      color: Colors.white,
                    ))
                : null,
            onEnter: (pin, state) async {
              bool isCorrect = await verifyPinCode(pinCodeEntered: pin);
              if (isCorrect) {
                PrivacyScreen.instance.unlock();
                await Navigator.of(context)
                    .pushReplacementNamed(RoutePaths.homeRoute);
              } else {
                state.codeIncorected();
              }
            },
            onChangedPin: (pin) {},
          );
        },
        onViewModelReady: (viewModel) {});
  }
}
