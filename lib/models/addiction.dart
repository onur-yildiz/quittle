import 'package:flutter/foundation.dart';

enum ConsumptionType { quantity, hour }

class Addiction {
  final String id;
  final String name;
  final String quitDate;
  final int consumptionType;
  final double dailyConsumption;
  final double unitCost;
  List<PersonalNote> personalNotes;

  Addiction({
    @required this.id,
    @required this.name,
    @required this.quitDate,
    @required this.consumptionType,
    @required this.dailyConsumption,
    this.unitCost = 0.0,
    this.personalNotes,
  });

  DateTime get quitDateTime {
    return DateTime.parse(quitDate);
  }

  // String get quitDateTimeFormatted {
  //   return DateFormat('dd/MM/yyyy').format(quitDateTime);
  // }

  Duration get abstinenceTime {
    return DateTime.now().difference(quitDateTime);
  }

  double get notUsedCount {
    if (consumptionType == 0) {
      return (dailyConsumption / Duration.hoursPerDay) * abstinenceTime.inHours;
    }
    return ((dailyConsumption / Duration.hoursPerDay) * abstinenceTime.inHours)
        .floorToDouble();
  }

  List<PersonalNote> get personalNotesDateSorted {
    List<PersonalNote> list = [...personalNotes];
    list.sort((a, b) {
      return DateTime.parse(b.date).compareTo(DateTime.parse(a.date));
    });
    return list;
  }
}

class PersonalNote {
  final String title;
  final String text;
  final String date;

  PersonalNote({
    @required this.title,
    @required this.text,
    @required this.date,
  });
}
