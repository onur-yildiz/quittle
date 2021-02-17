import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqlite_api.dart';

class DBHelper {
  static Future<Database> database() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, 'user.db'),
      onCreate: (db, version) async {
        await db.execute(
            'CREATE TABLE addictions(id TEXT PRIMARY KEY, name TEXT, quit_date TEXT, consumption_type INTEGER, daily_consumption REAL, unit_cost REAL)');
        await db.execute(
            'CREATE TABLE personal_notes(id INTEGER PRIMARY KEY, title TEXT, text TEXT, date TEXT)');
      },
      version: 1,
    );
  }

  static Future<void> insert(String table, Map<String, Object> data) async {
    final db = await DBHelper.database();
    db.insert(
      table,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, Object>>> getData(
    String table, [
    String id = '',
  ]) async {
    final db = await DBHelper.database();
    // print(await db.query('sqlite_master'));
    if (id == '') {
      return db.query(table);
    } else {
      return db.query(table,
          columns: ['id', 'title', 'text', 'date'],
          where: "'id' = ?",
          whereArgs: [id]);
    }
  }
}
