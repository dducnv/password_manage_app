import 'package:flutter/material.dart';

import 'package:password_manage_app/core/core.dart';
import 'package:password_manage_app/ui/widgets/widgets.dart';

class ExportBackupFileWidget extends StatelessWidget {
  final Function() onTap;
  const ExportBackupFileWidget({Key? key, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CardCustomWidget(
        padding: const EdgeInsets.all(0),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () async {
           
                bottomSheetPinPass(context: context, onSucess: onTap);
     
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Export backup file",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Icon(
                    Icons.download,
                  )
                  //switch
                ],
              ),
            ),
          ),
        ),);

        
  }

Future<void> bottomSheetPinPass({
    required BuildContext context,
    required Function() onSucess,
  }) async {
    await showModalBottomSheet(

      context: context,
      builder: (context) {
        return Builder(builder: (BuildContext context) {
          return PinCodeWidget(
              maxPinLength: 6,
          minPinLength: 6,
          onPressColorAnimation:
              MediaQuery.of(context).platformBrightness == Brightness.light
                  ? Colors.black
                  : Colors.white,
          centerBottomWidget: LocalAuthConfig.instance.isAvailableBiometrics  && LocalAuthConfig.instance.isOpenUseBiometric
              ? IconButton(
                  iconSize: 50,
                  onPressed: () async {
                    bool isAuth = await checkLocalAuth();
                    if (isAuth) {
                      onSucess.call();
                      Navigator.pop(context);
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
                 onSucess.call();
                 Navigator.pop(context);
              } else {
                state.codeIncorected();
              }
          },
          onChangedPin: (pin) {},
          );
        });
      },
      isScrollControlled: true,
    );
  }
}
