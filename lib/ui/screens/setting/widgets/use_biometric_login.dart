import 'package:flutter/material.dart';
import 'package:password_manage_app/core/core.dart';
import 'package:password_manage_app/ui/widgets/widgets.dart';

class UseBiometricLogin extends StatefulWidget {
  const UseBiometricLogin({Key? key}) : super(key: key);

  @override
  State<UseBiometricLogin> createState() => _UseBiometricLoginState();
}

class _UseBiometricLoginState extends State<UseBiometricLogin> {
  bool isCanUseBiometric = false;
  bool isOpenUseBiometric = false;

  @override
  void initState() {
    super.initState();
    checkBiometric();
  }

  void openBiometric() async {
    bool isAuth = await LocalAuthConfig.instance.authenticate();

    if (isAuth) {
      await SecureStorage.instance.save(
          SecureStorageKeys.isEnableLocalAuth.name, "true");
      setState(() {
        isOpenUseBiometric = true;
      });
    }
  }

  void checkBiometric() async {
    String? enableLocalAuth = await SecureStorage.instance
        .read(SecureStorageKeys.isEnableLocalAuth.name);

    if (enableLocalAuth == "false") {
      setState(() {
        isOpenUseBiometric = false;
      });
    } else {
      isOpenUseBiometric = true;
    }
    

    bool canCheckBiometrics =  LocalAuthConfig.instance.isAvailableBiometrics;

    setState(() {
      isCanUseBiometric = canCheckBiometrics;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isCanUseBiometric,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: CardCustomWidget(
            padding: const EdgeInsets.all(0),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {},
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        Strings.useBiometricLogin,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 4),
                      //switch
                      Switch(
                        value: isOpenUseBiometric,
                        onChanged: (value) {
                          if (value) {
                            openBiometric();
                          } else {
                            setState(() {
                              isOpenUseBiometric = false;
                            });
                            SecureStorage.instance.save(
                                SecureStorageKeys.isEnableLocalAuth.name, "false");
                          }
                        },
                        activeColor: Theme.of(context).colorScheme.primary,
                      ),
                    ],
                  ),
                ),
              ),
            )),
      ),
    );
  }
}
