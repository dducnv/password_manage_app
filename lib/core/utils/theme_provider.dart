import 'package:flutter/material.dart';
import 'package:password_manage_app/core/core.dart';
import 'package:password_manage_app/core/utils/global_keys.dart';
import 'package:password_manage_app/main.dart';
import 'package:provider/provider.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode _mode;
  ThemeMode get mode => _mode;
  ThemeProvider()
      : _mode = ThemeMode.values.firstWhere((e) => e.name == currentThemeMode);

  void toggleMode() {
    _mode = _mode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  void setMode(ThemeMode mode) {
    _mode = mode;

    SecureStorage.instance.save(
        SecureStorageKeys.themMode.toString(),
        Provider.of<ThemeProvider>(
                GlobalKeys.appRootNavigatorKey.currentContext!,
                listen: false)
            .mode
            .name);
    notifyListeners();
  }
}
