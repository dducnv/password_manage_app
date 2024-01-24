import 'package:flutter/material.dart';
import 'package:password_manage_app/core/core.dart';
import 'package:password_manage_app/ui/base/base.dart';
import 'package:password_manage_app/ui/screens/screen.dart';
import 'package:password_manage_app/ui/screens/setting/widgets/change_lang_widget.dart';
import 'package:password_manage_app/ui/screens/setting/widgets/set_theme_mode_widget.dart';

class SettingView extends StatefulWidget {
  const SettingView({Key? key}) : super(key: key);

  @override
  State<SettingView> createState() => SettingViewState();
}

class SettingViewState extends State<SettingView> {
  @override
  Widget build(BuildContext context) {
    return BaseView<SettingViewModel>(
        builder: (context, viewModel, _) {
          return Scaffold(
              appBar: AppBar(
                title: Text(Strings.settingsPageTitle),
              ),
              body: const SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(children: [
                    SetThemeModeWidget(),
                    SizedBox(height: 16),
                    ChangeLangWidget()
                  ]),
                ),
              ));
        },
        onViewModelReady: (SettingViewModel viewModel) {});
  }
}
