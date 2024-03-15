import 'package:flutter/material.dart';

class TimezoneProvider with ChangeNotifier {
  String _timezone = 'UTC';

  String get timezone => _timezone;

  void setTimezone(String newTimezone) {
    _timezone = newTimezone;
    notifyListeners();
  }
}

