import 'package:flutter/material.dart';
import 'package:password_manage_app/ui/base/base.dart';
import 'package:password_manage_app/ui/screens/register/register.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  @override
  Widget build(BuildContext context) {
    return BaseView<RegisterViewModel>(
        onViewModelReady: (viewModel) {},
        builder: (context, viewModel, child) {
          return Scaffold(
            backgroundColor: Theme.of(context).colorScheme.background,
            appBar: AppBar(
                elevation: 0,
                backgroundColor: Theme.of(context).colorScheme.background,
                title: ValueListenableBuilder<bool>(
                  valueListenable: viewModel.confirmScreen,
                  builder: (context, isConfirmScreen, child) {
                    return Text(isConfirmScreen ? "Confirm Pin" : "Create Pin");
                  },
                )),
            body: ValueListenableBuilder<bool>(
              valueListenable: viewModel.confirmScreen,
              builder: (context, isConfirmScreen, child) {
                return PageView(
                  controller: viewModel.pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    FistScreenWidget(viewModel: viewModel),
                    ConfirmScreenWidget(viewModel: viewModel),
                  ],
                );
              },
            ),
          );
        });
  }
}
