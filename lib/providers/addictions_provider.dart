import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import 'package:quittle/helpers/db_helper.dart';
import 'package:quittle/models/addiction.dart';
import 'package:quittle/models/gift.dart';
import 'package:quittle/models/personal_note.dart';

class AddictionsProvider with ChangeNotifier {
  List<Addiction> _addictions = [];

  List<Addiction> get addictions {
    return [..._addictions];
  }

  void insertAddiction(Addiction addiction) async {
    if (addiction.sortOrder == _addictions.length)
      _addictions.add(addiction);
    else
      _addictions.insert(addiction.sortOrder!, addiction);

    notifyListeners();
    await DBHelper.insert(
      'addictions',
      {
        'id': addiction.id,
        'name': addiction.name,
        'quit_date': addiction.quitDate,
        'consumption_type': addiction.consumptionType,
        'daily_consumption': addiction.dailyConsumption,
        'unit_cost': addiction.unitCost,
        'level': addiction.level,
        'achievement_level': addiction.achievementLevel,
        'sort_order': _addictions.length,
      },
    );
    reorderAddictions(_addictions.length, addiction.sortOrder!);
  }

  Future<Addiction> createAddiction(Map<String, dynamic> data) async {
    data['id'] = Uuid().v1();
    final newAddiction = Addiction(
      id: data['id'],
      name: data['name'],
      quitDate: data['quit_date'],
      consumptionType: data['consumption_type'],
      dailyConsumption: data['daily_consumption'],
      unitCost: data['unit_cost'],
      level: data['level'],
      achievementLevel: data['achievement_level'],
      sortOrder: _addictions.length,
      personalNotes: [],
      gifts: [],
    );

    await DBHelper.insert(
      'addictions',
      {
        'id': data['id'],
        'name': data['name'],
        'quit_date': data['quit_date'],
        'consumption_type': data['consumption_type'],
        'daily_consumption': data['daily_consumption'],
        'unit_cost': data['unit_cost'],
        'level': data['level'],
        'achievement_level': data['achievement_level'],
        'sort_order': _addictions.length,
      },
    );

    _addictions.add(newAddiction);
    notifyListeners();
    return newAddiction;
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
        var temp = Addiction(
          id: addiction['id'] as String,
          name: addiction['name'] as String,
          quitDate: addiction['quit_date'] as String,
          consumptionType: addiction['consumption_type'] as int,
          dailyConsumption: addiction['daily_consumption'] as double,
          unitCost: addiction['unit_cost'] as double,
          level: addiction['level'] as int?,
          achievementLevel: addiction['achievement_level'] as int?,
          sortOrder: addiction['sort_order'] as int?,
          personalNotes: [],
          gifts: [],
        );

        loadedAddictions.add(temp);
      },
    );
    loadedAddictions.sort((a, b) {
      return a.sortOrder!.compareTo(b.sortOrder!);
    });
    _addictions = loadedAddictions;
    notifyListeners();
  }

  //! gifts and notes are not deleted from db but user see them in app
  Future<Addiction> deleteAddiction(String id) async {
    final addiction = _addictions.firstWhere((addiction) => addiction.id == id);
    _addictions.remove(addiction);
    notifyListeners();
    final temp = _addictions.where((a) => a.sortOrder! > addiction.sortOrder!);
    temp.forEach((a) async {
      a.sortOrder = a.sortOrder! - 1;
      await DBHelper.update('addictions', 'sort_order', a.id, a.sortOrder);
    });
    await DBHelper.delete('addictions', id);
    return addiction;
    // ...
    // add a code that reverts the delete if db fails
  }

  void reorderAddictions(int oldIndex, int newIndex) async {
    // if reverting a delete, skip (see insertAddiction funt.)
    if (oldIndex != _addictions.length) {
      Addiction temp = _addictions.removeAt(oldIndex);
      _addictions.insert(newIndex, temp);
    }
    await DBHelper.reorder(
      'addictions',
      'sort_order',
      oldIndex,
      newIndex,
    );
    // ...
    // add a code that reverts the reorder if db fails
  }

  void createNote(Map<String, dynamic> data, String? id) async {
    final addiction = _addictions.firstWhere((addiction) => addiction.id == id);
    final newNote = PersonalNote(
      title: data['title'],
      text: data['text'],
      date: data['date'],
    );
    await DBHelper.insert(
      'personal_notes',
      {
        'id': id,
        'title': data['title'],
        'text': data['text'],
        'date': data['date'],
      },
    );
    addiction.personalNotes!.add(newNote);
    notifyListeners();
  }

  Future<void> fetchNotes(String? id) async {
    final List<PersonalNote> loadedNotes = [];
    final addiction = _addictions.firstWhere((addiction) => addiction.id == id);
    final notes = await DBHelper.getData(
      'personal_notes',
      'id',
      id,
    );
    notes.forEach((note) {
      loadedNotes.add(
        PersonalNote(
          title: note['title'] as String?,
          text: note['text'] as String?,
          date: note['date'] as String?,
        ),
      );
    });
    addiction.personalNotes = loadedNotes;
  }

  void createGift(Map<String, dynamic> data, String? id) async {
    final addiction = _addictions.firstWhere((addiction) => addiction.id == id);
    final giftId = Uuid().v1();
    final newGift = Gift(
      id: giftId,
      addictionId: id,
      name: data['name'],
      price: data['price'],
      sortOrder: addiction.gifts!.length,
    );
    await DBHelper.insert(
      'gifts',
      {
        'id': giftId,
        'addiction_id': id,
        'name': data['name'],
        'price': data['price'],
        'count': 0,
        'sort_order': addiction.gifts!.length,
      },
    );
    addiction.gifts!.add(newGift);
    notifyListeners();
  }

  Future<void> fetchGifts(String? id) async {
    final List<Gift> loadedGifts = [];
    final addiction = _addictions.firstWhere((addiction) => addiction.id == id);
    final gifts = await DBHelper.getData(
      'gifts',
      'addiction_id',
      id,
    );
    gifts.forEach((gift) {
      loadedGifts.add(
        Gift(
          id: gift['id'] as String?,
          addictionId: gift['addiction_id'] as String?,
          name: gift['name'] as String?,
          price: gift['price'] as double?,
          count: gift['count'] as int?,
          sortOrder: gift['sort_order'] as int?,
        ),
      );
    });
    loadedGifts.sort((a, b) => a.sortOrder!.compareTo(b.sortOrder!));
    addiction.gifts = loadedGifts;
    notifyListeners();
  }

  void deleteGift(Gift gift) async {
    final addiction =
        _addictions.firstWhere((addiction) => addiction.id == gift.addictionId);
    addiction.gifts!.remove(gift);
    notifyListeners();
    final temp =
        addiction.gifts!.where((g) => g.sortOrder! > addiction.sortOrder!);
    temp.forEach((g) async {
      g.sortOrder = g.sortOrder! - 1;
      await DBHelper.update('gifts', 'sort_order', g.id, g.sortOrder);
    });
    await DBHelper.delete('gifts', gift.id);
  }

  Future<void> reorderGifts(int oldIndex, int newIndex, String? id) async {
    final addiction = _addictions.firstWhere((addiction) => addiction.id == id);
    final temp = addiction.gifts!.removeAt(oldIndex);
    addiction.gifts!.insert(newIndex, temp);
    await DBHelper.reorder(
      'gifts',
      'sort_order',
      oldIndex,
      newIndex,
      id,
      'addiction_id',
    );
    // ...
    // add a code that reverts the reorder if db fails
  }

  void buyGift(Gift gift) async {
    gift.count = gift.count! + 1;
    await DBHelper.update(
      'gifts',
      'count',
      gift.id,
      gift.count,
    );
    notifyListeners();
  }
}
