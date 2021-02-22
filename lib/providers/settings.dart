import 'package:flutter/material.dart';

class Settings with ChangeNotifier {
  String _currency = '';

  String get currency {
    return _currency;
  }

  Future<void> updateCurrency(String newCurrency) {
    _currency = newCurrency;
    notifyListeners();
  }
}
