import 'package:flutter/material.dart';

class Settings with ChangeNotifier {
  String _currency = '\$'; //todo initial val on first load

  String get currency {
    return _currency;
  }

  String updateCurrency(String newCurrency) {
    _currency = newCurrency;
    notifyListeners();
    return currency;
  }
}
