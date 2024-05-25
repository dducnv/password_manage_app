import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:password_manage_app/core/core.dart';
import 'package:password_manage_app/core/domains/constants/locale.dart';
import 'package:password_manage_app/ui/route/route.dart';
import 'package:password_manage_app/ui/screens/screen.dart';
import 'package:password_manage_app/ui/screens/setting/widgets/widgets.dart';
import 'package:password_manage_app/ui/widgets/widgets.dart';
import 'package:provider/provider.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Stack(
          alignment: Alignment.centerLeft,
          children: [
            Container(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    Strings.helloText,
                    style: const TextStyle(
                        fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    Strings.selectLang,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.normal),
                  ),
                  Consumer<AppLanguageProvider>(
                      builder: (ctx, langProvider, _) {
                    EasyLocalization.of(context)
                        ?.setLocale(langProvider.appLocal);
                    return ChangeLangDropdown(
                      id: appListLocale
                          .firstWhere((element) =>
                              element.locale == langProvider.appLocal)
                          .id,
                      onChanged: (value) {
                        AppLocateModel appLocateModel = appListLocale
                            .firstWhere((element) => element.id == value);
                        Provider.of<AppLanguageProvider>(context, listen: false)
                            .changeLanguage(appLocateModel.locale);
                        EasyLocalization.of(context)
                            ?.setLocale(appLocateModel.locale);
                        setState(() {});
                      },
                    );
                  }),
                ],
              ),
            ),
            Container(
                alignment: Alignment.bottomCenter,
                child: CustomButtonWidget(
                  onPressed: () {
                    Navigator.pushNamed(context, RoutePaths.onboardingRoute);
                  },
                  text: Strings.continueText,
                ))
          ],
        ),
      ),
    );
  }
}
