import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider with ChangeNotifier {
  SharedPreferences? _prefs;

  String? get currency {
    return _prefs!.getString('currency');
  }

  bool? get receiveProgressNotifs {
    return _prefs!.getBool('allowProgressNotif');
  }

  bool? get receiveQuoteNotifs {
    return _prefs!.getBool('allowQuoteNotif');
  }

  Future<void> _initPrefs() async {
    if (_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
    }
  }

  Future<void> loadPrefs() async {
    await _initPrefs();
    _prefs!.getBool('allowProgressNotif') ??
        await _prefs!.setBool('allowProgressNotif', true);
    _prefs!.getString('allowQuoteNotif') ??
        await (_prefs!.setBool('allowQuoteNotif', true) as FutureOr<String?>);
    _prefs!.getString('currency') ??
        await (_prefs!.setString('currency', 'USD') as FutureOr<String?>);
    notifyListeners();
  }

  void updateCurrency(String newCurrency) async {
    await _initPrefs();
    await _prefs!.setString('currency', newCurrency);
    notifyListeners();
  }

  void allowQuoteNotif(bool isAllowed) async {
    await _initPrefs();
    await _prefs!.setBool('allowQuoteNotif', isAllowed);
    notifyListeners();
  }

  void allowProgressNotif(bool isAllowed) async {
    await _initPrefs();
    await _prefs!.setBool('allowProgressNotif', isAllowed);
    notifyListeners();
  }
}
