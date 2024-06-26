import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:password_manage_app/ui/route/route.dart';
import 'package:password_manage_app/ui/screens/screen.dart';
import 'package:password_manage_app/ui/screens/welcome/welcome_screen.dart';

class AppGenerateRoute {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    Widget? widget;

    switch (settings.name) {
      case RoutePaths.homeRoute:
        widget = const HomeView();
        break;
      case RoutePaths.welcomeScreen:
        widget = const WelcomeScreen();
        break;
      case RoutePaths.splashRote:
        widget = const SplashScreenView();
        break;
      case RoutePaths.onboardingRoute:
        widget = const OnboardingScreenView();
        break;
      case RoutePaths.settingRoute:
        widget = const SettingView();
        break;
      case RoutePaths.createAccount:
        final args = settings.arguments as Map<String, dynamic>;
        widget = CreateAccountView(
          categoryModel: args['categoryModel'],
        );
        break;
      case RoutePaths.detailsAccount:
        final args = settings.arguments as Map<String, dynamic>;
        widget = DetailsAccountView(
          id: args['id'],
        );
        break;
      case RoutePaths.updateAccount:
        final args = settings.arguments as Map<String, dynamic>;
        widget = UpdateAccountView(
          id: args['id'],
        );
        break;
      case RoutePaths.passwordGenerator:
        widget = const PasswordGeneratorView();
        break;
      case RoutePaths.localAuthView:
        widget = const LocalAuthView();
        break;
      case RoutePaths.register:
        widget = const RegisterView();
        break;
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
