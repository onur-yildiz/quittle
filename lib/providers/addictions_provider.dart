import 'package:flutter/material.dart';
import 'package:quittle/helpers/db_helper.dart';
import 'package:quittle/models/addiction.dart';
import 'package:quittle/models/gift.dart';
import 'package:quittle/models/personal_note.dart';
import 'package:uuid/uuid.dart';

class AddictionsProvider with ChangeNotifier {
  List<Addiction> _addictions = [];

  List<Addiction> get addictions {
    return [..._addictions];
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
      personalNotes: [],
      gifts: [],
    );
    _addictions.add(newAddiction);

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
      },
    );
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
          id: addiction['id'],
          name: addiction['name'],
          quitDate: addiction['quit_date'],
          consumptionType: addiction['consumption_type'],
          dailyConsumption: addiction['daily_consumption'],
          unitCost: addiction['unit_cost'],
          level: addiction['level'],
          personalNotes: [],
          gifts: [],
        );

        loadedAddictions.add(temp);

        _addictions = loadedAddictions;
      },
    );
    notifyListeners();
  }

  void createNote(Map<String, dynamic> data, String id) async {
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
    addiction.personalNotes.add(newNote);
    notifyListeners();
  }

  Future<void> fetchNotes(String id) async {
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
          title: note['title'],
          text: note['text'],
          date: note['date'],
        ),
      );
    });
    addiction.personalNotes = loadedNotes;
  }

  void createGift(Map<String, dynamic> data, String id) async {
    final addiction = _addictions.firstWhere((addiction) => addiction.id == id);
    final giftId = Uuid().v1();
    final newGift = Gift(
      id: giftId,
      addictionId: id,
      name: data['name'],
      price: data['price'],
      sortOrder: addiction.gifts.length,
    );
    await DBHelper.insert(
      'gifts',
      {
        'id': giftId,
        'addiction_id': id,
        'name': data['name'],
        'price': data['price'],
        'count': 0,
        'sort_order': addiction.gifts.length,
      },
    );
    addiction.gifts.add(newGift);
    notifyListeners();
  }

  void deleteGift(Gift gift) async {
    final Addiction addiction =
        _addictions.firstWhere((addiction) => addiction.id == gift.addictionId);
    addiction.gifts.remove(gift);
    await DBHelper.delete('gifts', gift.id);
    notifyListeners();
  }

  Future<void> fetchGifts(String id) async {
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
          id: gift['id'],
          addictionId: gift['addiction_id'],
          name: gift['name'],
          price: gift['price'],
          count: gift['count'],
          sortOrder: gift['sort_order'],
        ),
      );
    });
    loadedGifts.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    addiction.gifts = loadedGifts;
  }

  void buyGift(Gift gift) async {
    // final addiction = _addictions.firstWhere((addiction) => addiction.id == id);
    gift.count = gift.count + 1;
    await DBHelper.update(
      'gifts',
      'count',
      gift.id,
      gift.count,
    );
    notifyListeners();
  }
}

// TODO fix bought number of gifts not saving
