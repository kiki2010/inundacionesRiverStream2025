import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

class SettingsProvider with ChangeNotifier {
  bool _isBackgroundTaskEnabled = false;

  bool get isBackgroundTaskEnabled => _isBackgroundTaskEnabled;

  SettingsProvider() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isBackgroundTaskEnabled = prefs.getBool('background_task') ?? false;

    if (_isBackgroundTaskEnabled) {
      _startWorkManager();
    } else {
      _stopWorkManager();
    }

    notifyListeners();
  }

  Future<void> toggleBackgroundTask(bool value) async {
    _isBackgroundTaskEnabled = value;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('background_task', value);

    if (value) {
      _startWorkManager();
    } else {
      _stopWorkManager();
    }

    notifyListeners();
  }

  void _startWorkManager() async {
    await Workmanager().registerPeriodicTask(
      "task",
      "task",
      frequency: const Duration(minutes: 180),
    );
  }

  void _stopWorkManager() async {
    await Workmanager().cancelAll();
  }
}