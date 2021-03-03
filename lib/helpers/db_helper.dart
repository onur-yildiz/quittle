import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqlite_api.dart';

class DBHelper {
  static Future<Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(
      path.join(dbPath, 'user.db'),
      onCreate: (db, version) async {
        await db.execute(
            'CREATE TABLE addictions(id TEXT PRIMARY KEY, name TEXT, quit_date TEXT, consumption_type INTEGER, daily_consumption REAL, unit_cost REAL, level INT)');
        await db.execute('CREATE TABLE settings(currency TEXT)');
        await db.execute(
            'CREATE TABLE personal_notes(id TEXT, title TEXT, text TEXT, date TEXT)');
        await db.execute(
            'CREATE TABLE gifts(id TEXT PRIMARY KEY, addictionId TEXT, name TEXT, price REAL, count INTEGER)');
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

  static Future<void> update(String table, String id, dynamic data) async {
    final db = await DBHelper.database();
    if (table == 'gifts') {
      return await db
          .rawUpdate('UPDATE gifts SET count = ? WHERE id = ?', [data, id]);
    }
    if (table == 'addictions') {
      return await db.rawUpdate(
          'UPDATE addictions SET level = ? WHERE id = ?', [data, id]);
    }
  }

  static Future<void> delete(String table, String id) async {
    final db = await DBHelper.database();
    if (table == 'gifts') {
      db.rawDelete('DELETE FROM gifts WHERE id = ?', [id]);
    }
  }

  static Future<List<Map<String, Object>>> getData(String table,
      [String id = '']) async {
    final db = await DBHelper.database();
    if (table == 'addictions' && id == '') {
      return db.query(table);
    }
    if (table == 'addictions') {
      return db.rawQuery('SELECT * FROM addictions WHERE id = ?', [id]);
    }
    if (table == 'settings') {
      return db.query(table);
    }
    if (table == 'personal_notes') {
      return db.rawQuery('SELECT * FROM personal_notes WHERE id = ?', [id]);
    }
    if (table == 'gifts') {
      return db.rawQuery('SELECT * FROM gifts WHERE addictionId = ?', [id]);
    }
    return null;
  }
}
