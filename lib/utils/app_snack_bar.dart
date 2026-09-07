import 'package:flutter/material.dart';
import 'package:medtech_project/constant/app_colors.dart';

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

class AppSnackbar {
  static void show(String message, {Color? backgroundColor}) {
    scaffoldMessengerKey.currentState
      ?..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message), backgroundColor: backgroundColor),
      );
  }

  static void success(String message) {
    show(message, backgroundColor: AppColors.success);
  }

  static void error(String message) {
    show(message, backgroundColor: AppColors.error);
  }
}
