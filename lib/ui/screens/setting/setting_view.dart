import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:password_manage_app/core/core.dart';
import 'package:password_manage_app/core/domains/constants/locale.dart';
import 'package:password_manage_app/ui/base/base.dart';
import 'package:password_manage_app/ui/screens/screen.dart';
import 'package:password_manage_app/ui/screens/setting/widgets/widgets.dart';
import 'package:provider/provider.dart';

class SettingView extends StatefulWidget {
  const SettingView({Key? key}) : super(key: key);

  @override
  State<SettingView> createState() => SettingViewState();
}

class SettingViewState extends State<SettingView> {
  @override
  Widget build(BuildContext context) {
    print("build");
    return BaseView<SettingViewModel>(
        builder: (context, viewModel, _) {
          return Scaffold(
              appBar: AppBar(
                title: Text(Strings.settingsPageTitle),
              ),
              body: Consumer<AppLanguageProvider>(
                  builder: (ctx, langProvider, _) {
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(children: [
                      const SetThemeModeWidget(),
                      const SizedBox(height: 16),
                      ChangeLangWidget(
                        locale: langProvider.appLocal,
                        onTap: (value) {
                          AppLocateModel appLocateModel = appListLocale
                              .firstWhere((element) => element.id == value);
                          Provider.of<AppLanguageProvider>(context,
                                  listen: false)
                              .changeLanguage(appLocateModel.locale);
                          EasyLocalization.of(context)
                              ?.setLocale(appLocateModel.locale);
                          setState(() {});
                        },
                      ),
                      const SizedBox(height: 16),
                      const UseBiometricLogin()
                    ]),
                  ),
                );
              }));
        },
        onViewModelReady: (SettingViewModel viewModel) {});
  }
}
