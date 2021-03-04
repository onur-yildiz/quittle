import 'package:flutter/material.dart';
import 'package:quittle/helpers/db_helper.dart';
import 'package:quittle/models/settings.dart';
import 'package:workmanager/workmanager.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsProvider with ChangeNotifier {
  Settings _settings;

  // fetchSettings();
  // if (_settings.receiveQuoteNotifs) {
  //   Workmanager.registerOneOffTask(
  //     'quote-notification-oneoff',
  //     'quote-notification-oneoff',
  //     inputData: {
  //       'locale': this.local.localeName,
  //     },
  //   );
  // }
  // if (_settings.receiveQuoteNotifs) {
  //   Workmanager.registerPeriodicTask(
  //     'quote-notification',
  //     'quote-notification',
  //     inputData: {
  //       'locale': this.local.localeName,
  //     },
  //     frequency: Duration(days: 1),
  //   );
  // } else {
  //   Workmanager.cancelByUniqueName('quote-notifications');
  // }

  String get currency {
    return _settings.currency;
  }

  bool get receiveProgressNotifs {
    return _settings.receiveProgressNotifs;
  }

  bool get receiveQuoteNotifs {
    return _settings.receiveQuoteNotifs;
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
      final progressFlag = _settings.receiveProgressNotifs ? 1 : 0;
      final quoteFlag = _settings.receiveQuoteNotifs ? 1 : 0;
      await DBHelper.insert(
        'settings',
        {
          'id': 'v1',
          'currency': _settings.currency,
          'allow_progress_notification': progressFlag,
          'allow_quote_notification': quoteFlag,
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

  void allowQuoteNotif(bool isAllowed) async {
    int flag = isAllowed ? 1 : 0;
    await DBHelper.update(
      'settings',
      'allow_quote_notification',
      'v1',
      flag,
    );
    _settings.receiveQuoteNotifs = isAllowed;
    notifyListeners();
  }

  void allowProgressNotif(bool isAllowed) async {
    int flag = isAllowed ? 1 : 0;
    await DBHelper.update(
      'settings',
      'allow_progress_notification',
      'v1',
      flag,
    );
    _settings.receiveProgressNotifs = isAllowed;
    notifyListeners();
  }
}
