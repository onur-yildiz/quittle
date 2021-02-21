import 'package:flutter/cupertino.dart';

class Refresh with ChangeNotifier {
  static const _refresh = false;

  bool refresh() {
    notifyListeners();
    print('refresh');
    return _refresh;
  }
}
