import 'package:flutter/foundation.dart';

enum ConsumptionType { quantity, hour }

class Addiction {
  final String name;
  final DateTime quitDate;
  final ConsumptionType consumptionType;
  final double dailyConsumption;
  final double unitCost;
  final List<PersonalNote> personalNotes;

  Addiction({
    @required this.name,
    @required this.quitDate,
    @required this.consumptionType,
    @required this.dailyConsumption,
    this.unitCost = 0.0,
    this.personalNotes,
  });
}

class PersonalNote {
  final String title;
  final String text;
  final DateTime date;

  PersonalNote({
    this.title = '',
    @required this.text,
    @required this.date,
  });
}
