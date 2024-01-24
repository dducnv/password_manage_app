import 'package:flutter/material.dart';
import 'package:password_manage_app/ui/base/base.dart';
import 'package:password_manage_app/ui/screens/screen.dart';

class SplashScreenView extends StatefulWidget {
  const SplashScreenView({Key? key}) : super(key: key);

  @override
  State<SplashScreenView> createState() => _SplashScreenViewState();
}

class _SplashScreenViewState extends State<SplashScreenView> {
  @override
  Widget build(BuildContext context) {
    return BaseView<SplashScreenViewModel>(
        builder: (context, viewModel, child) {
      return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.primary,
          body: Center(
            child: Container(
                width: 250,
                height: 250,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                  isAntiAlias: true,
                  filterQuality: FilterQuality.high,
                  image: AssetImage("assets/images/app_logo.png"),
                  alignment: Alignment.center,
                ))),
          ));
    }, onViewModelReady: (viewModel) {
      viewModel.init();
    });
  }
}
