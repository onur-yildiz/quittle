import 'package:flutter/foundation.dart';
import 'package:flutter_quit_addiction_app/models/personal_note.dart';
import 'package:flutter_quit_addiction_app/models/gift.dart';

enum ConsumptionType { quantity, hour }

const _achievementDurations = [
  Duration(days: 1),
  Duration(days: 3),
  Duration(days: 7),
  Duration(days: 30),
  Duration(days: 60),
  Duration(days: 90),
  Duration(days: 180),
  Duration(days: 270),
  Duration(days: 360),
];

List<Duration> get getAchievementDurations {
  return [..._achievementDurations];
}

class Addiction {
  final String id;
  final String name;
  final String quitDate;
  final int consumptionType;
  final double dailyConsumption;
  final double unitCost;
  List<PersonalNote> personalNotes;
  List<Gift> gifts;
  List<Duration> achievements;
  int level;

  Addiction({
    @required this.id,
    @required this.name,
    @required this.quitDate,
    @required this.consumptionType,
    @required this.dailyConsumption,
    @required this.unitCost,
    this.personalNotes,
    this.gifts,
    this.level,
  }) {
    this.achievements = _achievementDurations;
  }

  DateTime get quitDateTime {
    return DateTime.parse(quitDate);
  }

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

  double get totalSaved {
    return notUsedCount * dailyConsumption;
  }

  double get totalSpent {
    double total = 0.0;
    gifts.forEach((gift) {
      total += gift.price * gift.count;
    });
    return total;
  }

  double get availableMoney {
    return totalSaved - totalSpent;
  }

  List<PersonalNote> get personalNotesDateSorted {
    List<PersonalNote> list = [...personalNotes];
    list.sort((a, b) {
      return DateTime.parse(b.date).compareTo(DateTime.parse(a.date));
    });
    return list;
  }
}
