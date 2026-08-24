import 'dart:async';

import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class InternetChecker {
  InternetChecker._();

  static final InternetChecker instance = InternetChecker._();

  Stream<InternetStatus> get statusStream {
    return InternetConnection().onStatusChange;
  }

  Future<bool> get isConnected async {
    return await InternetConnection().hasInternetAccess;
  }
}