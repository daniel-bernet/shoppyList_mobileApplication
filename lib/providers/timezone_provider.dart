import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TimezoneProvider with ChangeNotifier {
  String _timezone = 'Europe/Berlin';

  TimezoneProvider() {
    loadTimezone();
  }

  String get timezone => _timezone;

  void setTimezone(String newTimezone) async {
    _timezone = newTimezone;
    await saveTimezone(newTimezone);
    notifyListeners();
  }

  Future<void> loadTimezone() async {
    final prefs = await SharedPreferences.getInstance();
    _timezone = prefs.getString('timezone') ?? 'UTC';
    notifyListeners();
  }

  Future<void> saveTimezone(String timezone) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('timezone', timezone);
  }
}
