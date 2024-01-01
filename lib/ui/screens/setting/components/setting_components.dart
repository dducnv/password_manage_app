import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:password_manage_app/core/core.dart';
import 'package:password_manage_app/ui/screens/setting/setting.dart';
import 'package:provider/provider.dart';

extension SettingComponents on SettingViewState {
  Widget buildThemeMode() {
    return ValueListenableBuilder<ThemeMode>(
        valueListenable: ValueNotifier<ThemeMode>(
            Provider.of<ThemeProvider>(context, listen: true).mode),
        builder: (_, value, __) {
          return IconButton(
              onPressed: () {
                HapticFeedback.mediumImpact();

                Provider.of<ThemeProvider>(context, listen: false).toggleMode();

                SecureStorage.instance.save(
                    SecureStorageKeys.themMode.toString(),
                    Provider.of<ThemeProvider>(context, listen: false)
                        .mode
                        .name);
              },
              icon: value == ThemeMode.dark
                  ? const Icon(Icons.light_mode)
                  : value == ThemeMode.light
                      ? const Icon(Icons.dark_mode)
                      : const Icon(Icons.settings_system_daydream));
        });
  }
}
