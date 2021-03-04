import 'package:flutter/material.dart';
import 'package:quittle/helpers/db_helper.dart';
import 'package:quittle/models/settings.dart';

class SettingsProvider with ChangeNotifier {
  Settings _settings;

  String get currency {
    return _settings.currency;
  }

  Future<void> fetchSettings() async {
    final settings = await DBHelper.getData('settings');

    if (settings != null && settings.length != 0) {
      _settings = Settings(
        currency: settings[0]['currency'],
        receiveProgressNotifs:
            settings[0]['allow_progress_notification'] == 0 ? false : true,
        receiveQuoteNotifs:
            settings[0]['allow_quote_notification'] == 0 ? false : true,
      );
    } else {
      _settings = Settings();
      await DBHelper.insert(
        'settings',
        {
          'id': 'v1',
          'currency': _settings.currency,
          'allow_progress_notification': _settings.receiveProgressNotifs,
          'allow_quote_notification': _settings.receiveQuoteNotifs,
        },
      );
    }
    notifyListeners();
  }

  void updateCurrency(String newCurrency) async {
    await DBHelper.update(
      'settings',
      'currency',
      'v1',
      newCurrency,
    );
    _settings.currency = newCurrency;
    notifyListeners();
  }
}
