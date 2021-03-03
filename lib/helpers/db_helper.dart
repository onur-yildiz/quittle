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
            'CREATE TABLE addictions(id TEXT PRIMARY KEY, name TEXT, quit_date TEXT, consumption_type INTEGER, daily_consumption REAL, unit_cost REAL, level INTEGER)');
        await db.execute(
            'CREATE TABLE settings(id INTEGER, currency TEXT, allow_progress_notification INTEGER, allow_quote_notification INTEGER)');
        await db.execute(
            'CREATE TABLE personal_notes(id TEXT, title TEXT, text TEXT, date TEXT)');
        await db.execute(
            'CREATE TABLE gifts(id TEXT PRIMARY KEY, addiction_id TEXT, name TEXT, price REAL, count INTEGER, sort_order INTEGER)');
      },
      version: 1,
    );
  }

  static Future<void> insert(String table, Map<String, Object> data) async {
    final db = await DBHelper.database();
    return db.insert(
      table,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<void> update(
    String table,
    String column,
    String id,
    dynamic data,
  ) async {
    final db = await DBHelper.database();
    return db
        .rawUpdate('UPDATE $table SET $column = ? WHERE id = ?', [data, id]);
  }

  //? maybe a more generalized version of this function
  static Future<void> switchGiftOrders(
    String table,
    String column,
    int oldIndex,
    int newIndex,
  ) async {
    final db = await DBHelper.database();
    await db.rawUpdate(
      'UPDATE $table SET $column = ? WHERE $column = ?',
      [-1, oldIndex],
    );
    await db.rawUpdate(
      'UPDATE $table SET $column = ? WHERE $column = ?',
      [oldIndex, newIndex],
    );
    return db.rawUpdate(
      'UPDATE $table SET $column = ? WHERE $column = ?',
      [newIndex, -1],
    );
  }

  static Future<void> delete(String table, String id) async {
    final db = await DBHelper.database();
    return db.rawDelete('DELETE FROM $table WHERE id = ?', [id]);
  }

  static Future<List<Map<String, Object>>> getData(
    String table, [
    String column = '',
    String id = '',
  ]) async {
    final db = await DBHelper.database();
    if (id == '' || column == '') {
      return db.query(table);
    }
    return db.rawQuery('SELECT * FROM $table WHERE $column = ?', [id]);
  }
}
