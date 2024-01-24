import 'package:flutter/material.dart' hide Key;
import 'package:password_manage_app/core/core.dart';

class Constants {
  static double get horizontalPadding {
    return 20.0;
  }

  static Size getScreenSize() {
    BuildContext? context = GlobalKeys.appRootNavigatorKey.currentContext;
    if (context != null) {
      return MediaQuery.of(context).size;
    } else {
      return const Size(0, 0);
    }
  }

  static Size getStandardSize() {
    return const Size(375, 812);
  }

  static double getWidth(double width) {
    return (width / Constants.getStandardSize().width) *
        Constants.getScreenSize().width;
  }

  static double getHeight(double height) {
    return (height / Constants.getStandardSize().height) *
        Constants.getScreenSize().height;
  }

  static String emailSupport() {
    return "nguyenmanhhung131298@gmail.com";
  }

  // static String pinCodeKeyEncrypt =
  //     "TWtwRFNGRTFRekZCTkZnMVJUZEJXQ0JEU0ZvNUpUVTVWMWszUmtOQlVVRTFVeXM0VEZaRVRpMDVWQzgwTkVnNFN5NUVSaTlHT0ZjMVdUbzRNVlJCTjFJMVVFMDVXUzVHTFZwQw==";

  // static String infoEncryptKey =
  //     "SxkxGOV6WC+BKNnE/JiBFfHaBbk7Ev2Udd7LQwA1o2hBayINYrktVwsHkrffAOd0rC/7IMi4YdCp9CIWb52vSPJUsvCzAN29KD/aII1IRrj8Amuah6XNFfXnF+hGvVKsOreOTJbv8SwKka2DyO1aBo0QCW151E8XXYBoxSyQCfldngrmuQqhaThxPh83Y7N9";
}
