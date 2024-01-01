import 'package:flutter/material.dart';
import 'package:password_manage_app/ui/base/base.dart';

class SettingViewModel extends BaseViewModel {
  ValueNotifier<ThemeMode> themeMode =
      ValueNotifier<ThemeMode>(ThemeMode.system);

  void changeThemeMode(ThemeMode mode) {
    themeMode.value = mode;

    notifyListeners();
  }
}
