import 'package:flutter/material.dart';
import 'package:flutter_quit_addiction_app/helpers/db_helper.dart';
import 'package:flutter_quit_addiction_app/models/addiction.dart';
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
    notifyListeners();
  }

  Future<void> fetchAddictions() async {
    final List<Addiction> loadedAddictions = [];

    final addictionsTable = await DBHelper.getData('addictions');
    if (addictionsTable.length <= 0) {
      _addictions = [];
      notifyListeners();
      return;
    }
    addictionsTable.forEach(
      (addiction) async {
        // ! COMMENTED CODE ABOVE MAKES ADDICTIONS NOT LOAD SOMETIMES

        var temp = Addiction(
          id: addiction['id'],
          name: addiction['name'],
          quitDate: addiction['quit_date'],
          consumptionType: addiction['consumption_type'],
          dailyConsumption: addiction['daily_consumption'],
          unitCost: addiction['unit_cost'],
          personalNotes: [],
        );
        loadedAddictions.add(temp);
        print(loadedAddictions.length);
        _addictions = loadedAddictions;
      },
    );
    notifyListeners();
  }

  void createNote(Map<String, dynamic> data, String id) {
    final addiction = _addictions.firstWhere((addiction) => addiction.id == id);
    final newNote = PersonalNote(
      title: data['title'],
      text: data['text'],
      date: data['date'],
    );
    addiction.personalNotes.add(newNote);

    DBHelper.insert(
      'personal_notes',
      {
        'id': id,
        'title': data['title'],
        'text': data['text'],
        'date': data['date'],
      },
    );

    print(_addictions
            .firstWhere((addiction) => addiction.id == id)
            .personalNotes
            .length
            .toString() +
        ' LENGTH');
    notifyListeners();
  }

  Future<void> fetchNotes(String id) async {
    final List<PersonalNote> loadedNotes = [];
    final addiction = _addictions.firstWhere((addiction) => addiction.id == id);
    final notes = await DBHelper.getData('personal_notes', id);
    notes.forEach((note) {
      loadedNotes.add(
        PersonalNote(
          title: note['title'],
          text: note['text'],
          date: note['date'],
        ),
      );
    });
    addiction.personalNotes = loadedNotes;
    // notifyListeners();
  }

  // Future<void> toggleAddiction(String addictionId, bool isExpanded) async {
  //   if (isExpanded) {
  //     _addictions = [
  //       addictions.firstWhere((addiction) => addictionId == addiction.id)
  //     ];
  //     print('picked');
  //   } else {
  //     fetchAddictions();
  //   }
  //   notifyListeners();
  // }

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
