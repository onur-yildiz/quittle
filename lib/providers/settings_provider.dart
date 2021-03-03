import 'package:flutter/material.dart';
import 'package:flutter_quit_addiction_app/helpers/db_helper.dart';
import 'package:flutter_quit_addiction_app/models/settings.dart';

class SettingsProvider with ChangeNotifier {
  Settings _settings = Settings(currency: 'USD');

  String get currency {
    return _settings.currency;
  }

  Future<void> fetchSettings() async {
    final settings = await DBHelper.getData('settings');

    if (settings != null && settings.length != 0) {
      _settings = Settings(
        currency: settings[0]['currency'],
      );
    } else {
      _settings = Settings();
    }
    notifyListeners();
  }

  void updateCurrency(String newCurrency) async {
    await DBHelper.insert(
      'settings',
      {'currency': newCurrency},
    );
    _settings.currency = newCurrency;
    notifyListeners();
  }
}
