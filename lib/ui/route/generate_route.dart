import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:password_manage_app/ui/route/route.dart';
import 'package:password_manage_app/ui/screens/screen.dart';

class AppGenerateRoute {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    Widget? widget;

    switch (settings.name) {
      case RoutePaths.homeRoute:
        widget = const HomeView();
        break;
      case RoutePaths.settingRoute:
        widget = const SettingView();
        break;
      case RoutePaths.createAccount:
        widget = const CreateAccountView();
        break;
      case RoutePaths.detailsAccount:
        final args = settings.arguments as Map<String, dynamic>;
        widget = DetailsAccountView(
          id: args['id'],
        );
        break;
      case RoutePaths.passwordGenerator:
        widget = const PasswordGeneratorView();
    }
    return Platform.isIOS
        ? CupertinoPageRoute(
            settings: RouteSettings(name: settings.name),
            builder: (context) => widget!)
        : PageRouteBuilder(
            settings: settings,
            pageBuilder: (_, a1, a2) => widget!,
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              const begin = Offset(1.0, 0.0);
              const end = Offset.zero;
              const curve = Curves.ease;

              var tween =
                  Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

              return SlideTransition(
                position: animation.drive(tween),
                child: child,
              );
            },
          );
  }
}
