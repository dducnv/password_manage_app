import 'package:flutter/material.dart';
import 'package:password_manage_app/ui/base/base_view_model.dart';

class MainViewModel extends BaseViewModel {
  final pageViewController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  final ValueNotifier<int> currentPage = ValueNotifier<int>(0);

  void handleChangePage(int index) {
    currentPage.value = index;
    pageViewController.animateToPage(index,
        duration: const Duration(milliseconds: 300), curve: Curves.ease);
  }
}
