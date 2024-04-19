import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:password_manage_app/core/utils/utils.dart';
import 'package:password_manage_app/ui/widgets/widgets.dart';
import 'package:provider/provider.dart';

class SetThemeModeWidget extends StatelessWidget {
  const SetThemeModeWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    return CardCustomWidget(
        padding: const EdgeInsets.all(0),
        child: ValueListenableBuilder<ThemeMode>(
            valueListenable: ValueNotifier<ThemeMode>(
                Provider.of<ThemeProvider>(context, listen: true).mode),
            builder: (_, value, __) {
              return Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    HapticFeedback.mediumImpact();
                    showDialog(
                        context: context,
                        builder: (_) {
                          return AlertDialog(
                            clipBehavior: Clip.antiAlias,
                            contentPadding: const EdgeInsets.all(0),
                            title:  Text(Strings.themeMode),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListTile(
                                  leading: value == ThemeMode.system
                                      ? const Icon(Icons.check)
                                      : const SizedBox.shrink(),
                                  title:  Text(Strings.system),
                                  onTap: () {
                                    Provider.of<ThemeProvider>(context,
                                            listen: false)
                                        .setMode(ThemeMode.system);
                                    Navigator.pop(context);
                                  },
                                ),
                                ListTile(
                                  leading: value == ThemeMode.light
                                      ? const Icon(Icons.check)
                                      : const SizedBox.shrink(),
                                  title:  Text(Strings.light),
                                  onTap: () {
                                    Provider.of<ThemeProvider>(context,
                                            listen: false)
                                        .setMode(ThemeMode.light);
                                    Navigator.pop(context);
                                  },
                                ),
                                ListTile(
                                  leading: value == ThemeMode.dark
                                      ? const Icon(Icons.check)
                                      : const SizedBox.shrink(),
                                  title:  Text(Strings.dark),
                                  onTap: () {
                                    Provider.of<ThemeProvider>(context,
                                            listen: false)
                                        .setMode(ThemeMode.dark);
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            ),
                          );
                        });
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          Strings.themeMode,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        SizedBox(
                            child: value != ThemeMode.dark
                                ? const Icon(Icons.light_mode)
                                : value == ThemeMode.light
                                    ? const Icon(Icons.dark_mode)
                                    : brightness == Brightness.light
                                        ? const Icon(Icons.dark_mode)
                                        : const Icon(Icons.light_mode))
                      ],
                    ),
                  ),
                ),
              );
            }));
  }
}
