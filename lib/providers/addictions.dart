import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quit_addiction_app/helpers/db_helper.dart';
import 'package:flutter_quit_addiction_app/providers/addiction.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class Addictions with ChangeNotifier {
  List<Addiction> _addictions = [];

  List<Addiction> get addictions {
    return [..._addictions];
  }

  Future<void> createAddiction(Map<String, dynamic> data) async {
    data['id'] = Uuid().v1();
    final newAddiction = Addiction(
      id: data['id'],
      name: data['name'],
      quitDate: data['quit_date'],
      consumptionType: data['consumption_type'],
      dailyConsumption: data['daily_consumption'],
      unitCost: data['unit_cost'],
    );
    _addictions.add(newAddiction);

    DBHelper.insert(
      'addictions',
      {
        'id': data['id'],
        'name': data['name'],
        'quit_date': data['quit_date'],
        'consumption_type': data['consumption_type'],
        'daily_consumption': data['daily_consumption'],
        'unit_cost': data['unit_cost'],
      },
    );
    print(json.encode(data));
    notifyListeners();
  }

  // Future<void> addPersonalNote(
  //     {String id, String title = '', String text, String date}) async {
  //   final newPersonalNote = PersonalNote(
  //     title: title,
  //     text: text,
  //     date: date,
  //   );
  //   _addictions
  //       .firstWhere((addiction) => addiction.id == id)
  //       .personalNotes
  //       .add(newPersonalNote);
  //   DBHelper.insert('personal_notes', {
  //     'id': id,
  //     'title': title,
  //     'text': text,
  //     'date': date != null ? date : DateTime.now(),
  //   });
  //   notifyListeners();
  // }
}
