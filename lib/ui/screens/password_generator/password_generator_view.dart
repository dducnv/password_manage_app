import 'package:flutter/material.dart';
import 'package:password_manage_app/ui/base/base.dart';
import 'package:password_manage_app/ui/screens/screen.dart';

class PasswordGeneratorView extends StatelessWidget {
  const PasswordGeneratorView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<PasswordGeneratorViewModel>(
        onViewModelReady: (viewModel) {},
        builder: (context, viewModel, _) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Password Generator"),
            ),
            body: const Center(
              child: Text(""),
            ),
          );
        });
  }
}
