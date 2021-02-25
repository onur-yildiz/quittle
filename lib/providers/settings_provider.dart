import 'package:flutter/material.dart';

class SettingsProvider with ChangeNotifier {
  String _currency = 'USD'; //todo initial val on first load

  String get currency {
    return _currency;
  }

  void updateCurrency(String newCurrency) {
    _currency = newCurrency;
    notifyListeners();
  }
}
