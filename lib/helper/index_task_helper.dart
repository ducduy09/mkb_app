import 'package:sqflite/sqflite.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';

class IndexTaskHelper {
  // ignore: prefer_final_fields
  static String _tableName = "indexTasks";
  static Future<void> _createDatabase(Database db, int version) async {
    await db.execute(
        'CREATE TABLE IF NOT EXISTS $_tableName(taskId text, userId integer, taskName text, note text, createTime text default CURRENT_TIMESTAMP, status int default 0, primary key(taskId, userId), FOREIGN KEY (userId) REFERENCES userLogin(userId))');
  }

  static Future<int> insertTaskNow(
      String taskId, int userId, String taskName, String note) async {
    final db = await _openDatabase();
    final data = {
      'taskId': taskId,
      'userId': userId,
      'taskName': taskName,
      'note': note
    };
    return await db.insert(_tableName, data);
  }

  static Future<int> insertTask(String taskId, int userId, String taskName,
      String note, String time) async {
    final db = await _openDatabase();
    final data = {
      'taskId': taskId,
      'userId': userId,
      'taskName': taskName,
      'note': note,
      'createTime': time
    };
    return await db.insert(_tableName, data);
  }

  static Future<List<Map<String, dynamic>>> getData() async {
    final db = await _openDatabase();
    return await db.query('indexTasks');
  }

  static Future<Database> _openDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'MkbTech.db');
    return openDatabase(path, version: 1, onCreate: _createDatabase);
  }

  static Future<List<Map<String, dynamic>>> getTaskById(
      int adId, String id) async {
    var dbClient = await _openDatabase();
    var query = await dbClient.rawQuery(
        "SELECT * FROM $_tableName WHERE userId = '$adId' and taskId = '$id'");
    return query;
  }

  static getListTask(int userId) async {
    var dbClient = await _openDatabase();
    var query = await dbClient.rawQuery(
        "SELECT * FROM $_tableName WHERE userId = '$userId'");
    return query;
  }

  static Future<void> changeStatus(String id, int userID, int status, String time) async {
    Database db = await _openDatabase();
    db.rawUpdate(
        "UPDATE $_tableName SET status = $status WHERE taskId = '$id' and userId = $userID");
  }

  static Future<List<Map<String, dynamic>>> checkTaskId(String id, int userID) async {
    Database db = await _openDatabase();
    var query = await db.rawQuery(
        "SELECT * FROM $_tableName WHERE taskId = '$id' and userId = $userID");
    return query;
  }
}
