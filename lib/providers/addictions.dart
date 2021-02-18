import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quit_addiction_app/helpers/db_helper.dart';
import 'package:flutter_quit_addiction_app/providers/addiction.dart';
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

  Future<void> fetchAddictions() async {
    final List<Addiction> loadedAddictions = [];
    final List<PersonalNote> personalNotes = [];

    final addictionsTable = await DBHelper.getData('addictions');
    addictionsTable.forEach((addiction) async {
      // 'CREATE TABLE addictions(id TEXT PRIMARY KEY, name TEXT, quit_date TEXT, consumption_type INTEGER, daily_consumption REAL, unit_cost REAL); CREATE TABLE personal_notes(id INTEGER PRIMARY KEY title TEXT, text TEXT, date TEXT)'), //TODO TABLES
      final notesTable =
          await DBHelper.getData('personal_notes', addiction['id']);
      notesTable.forEach((note) {
        personalNotes.add(PersonalNote(
          // id: note['id'],
          title: note['title'],
          text: note['text'],
          date: note['date'],
        ));
      });

      loadedAddictions.add(
        Addiction(
          id: addiction['id'],
          name: addiction['name'],
          quitDate: addiction['quit_date'],
          consumptionType: addiction['consumption_type'],
          dailyConsumption: addiction['daily_consumption'],
          unitCost: addiction['unit_cost'],
          personalNotes: personalNotes,
        ),
      );
    });
    _addictions = loadedAddictions;
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
