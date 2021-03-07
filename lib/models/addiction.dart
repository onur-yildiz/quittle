import 'package:flutter/foundation.dart';
import 'package:quittle/util/progress_constants.dart';
import 'package:quittle/models/personal_note.dart';
import 'package:quittle/models/gift.dart';

enum ConsumptionType { quantity, hour }

class Addiction {
  final String id;
  final String name;
  final String quitDate;
  final int consumptionType;
  final double dailyConsumption;
  final double unitCost;
  List<PersonalNote> personalNotes;
  List<Gift> gifts;
  int level;
  int achievementLevel;
  int sortOrder;

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
    this.achievementLevel,
    this.sortOrder,
  });

  DateTime get quitDateTime {
    return DateTime.parse(quitDate);
  }

  Duration get abstinenceTime {
    return DateTime.now().difference(quitDateTime);
  }

  double get notUsedCount {
    if (consumptionType == 0) {
      return (dailyConsumption / Duration.secondsPerDay) *
          abstinenceTime.inSeconds;
    }
    return ((dailyConsumption / Duration.secondsPerDay) *
            abstinenceTime.inSeconds)
        .floorToDouble();
  }

  double get totalSaved {
    return notUsedCount * unitCost;
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
