import 'package:flutter/material.dart';
import 'package:password_manage_app/core/core.dart';
import 'package:password_manage_app/core/extensions/extensions.dart';
import 'package:password_manage_app/core/utils/dialog_content.dart';

class BaseViewModel extends ChangeNotifier {
  State? widgetState;
  ViewState _state = ViewState.idle;

  ViewState get state => _state;

  void showDialog(DialogContent dialogContent) {
    if (widgetState == null) {
      return;
    }
    widgetState!.widget.showCustomDialog(widgetState!.context, dialogContent);
  }

  void setState(ViewState state) {
    _state = state;
    notifyListeners();
  }
}
