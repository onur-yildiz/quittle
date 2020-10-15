import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqlite_api.dart';

class DBHelper {
  static Future<Database> database() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, 'user.db'),
      onCreate: (db, version) => db.execute(
          'CREATE TABLE addictions(id INTEGER PRIMARY KEY, name TEXT, quit_date TEXT, consumption_type INTEGER, daily_consumption REAL, unit_cost REAL); CREATE TABLE personal_notes(title TEXT, text TEXT)'), //TODO TABLES
    );
  }
}
