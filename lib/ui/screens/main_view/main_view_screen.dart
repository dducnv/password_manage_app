import 'package:flutter/material.dart';

import 'package:password_manage_app/ui/base/base.dart';
import 'package:password_manage_app/ui/screens/main_view/main_view_model.dart';
import 'package:password_manage_app/ui/screens/screen.dart';

class MainView extends StatefulWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  MainViewState createState() => MainViewState();
}

class MainViewState extends State<MainView> {
  @override
  Widget build(BuildContext context) {
    return BaseView<MainViewModel>(
      onViewModelReady: (MainViewModel viewModel) async {},
      builder: (context, viewModel, child) {
        return Scaffold(
          floatingActionButton: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              FloatingActionButton(
                shape: const CircleBorder(),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CreateAccountView()));
                },
                child: const Icon(Icons.add),
              ),
              const SizedBox(height: 10),
            ],
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          body: const HomeView(),
        );
      },
    );
  }
}
