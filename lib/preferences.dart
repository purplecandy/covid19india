import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Preferences with ChangeNotifier {
  String _defaultStateName;

  Preferences() {
    _init();
  }

  String get defaultStateName => _defaultStateName;
  bool get initialized => _defaultStateName != null;

  void _init() async {
    final pref = await SharedPreferences.getInstance();
    if (pref.containsKey("defaultStateName")) {
      _defaultStateName = pref.getString("defaultStateName");
    } else {
      pref.setString("defaultStateName", "");
      _defaultStateName = "";
    }
    notifyListeners();
  }

  void setDefault(String stateName) async {
    if (stateName.length > 0) {
      _defaultStateName = stateName;
      final pref = await SharedPreferences.getInstance();
      pref.setString("defaultStateName", _defaultStateName);
      notifyListeners();
    }
  }
}
