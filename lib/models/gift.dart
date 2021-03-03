import 'package:flutter/foundation.dart';

class Gift {
  final String id;
  final String addictionId;
  final String name;
  final double price;
  int sortOrder;
  int count;

  Gift({
    @required this.id,
    @required this.addictionId,
    @required this.name,
    @required this.price,
    @required this.sortOrder,
    int count,
  }) {
    this.count = count ?? 0;
  }
}
