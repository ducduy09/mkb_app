// ignore_for_file: avoid_print

import 'package:sqflite/sqflite.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
//import 'package:mkb_technology/models/user_login.dart';

class TaskHelper {
  // ignore: prefer_final_fields
  static String _tableName = "tasks";
  static Future<void> _createDatabase(Database db, int version) async {
    await db.execute(
        'CREATE TABLE IF NOT EXISTS $_tableName(taskId text primary key, taskChildId text, taskChildName text, content text, createTime text default CURRENT_TIMESTAMP, completeTime text, status int default 0, primary key(taskId, taskChildId), FOREIGN KEY (taskId) REFERENCES tasks(taskId))');
  }

  static Future<int> insertTaskNow(String taskId, String taskChildId,
      String taskName, String content) async {
    final db = await _openDatabase();
    final data = {
      'taskId': taskId,
      'taskChildId': taskChildId,
      'taskName': taskName,
      'content': content,
      'status': 0
    };
    return await db.insert(_tableName, data);
  }

  static Future<int> insertTask(String taskId, String taskChildId,
      String taskName, String content, String time) async {
    final db = await _openDatabase();
    final data = {
      'taskId': taskId,
      'taskChildId': taskChildId,
      'taskName': taskName,
      'content': content,
      'createTime': time,
      'status': 0
      //'warehourseCode': code,
    };
    return await db.insert(_tableName, data);
  }

  static Future<List<Map<String, dynamic>>> getData() async {
    final db = await _openDatabase();
    return await db.query('tasks');
  }

  static Future<Database> _openDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'MkbTech.db');
    return openDatabase(path, version: 1, onCreate: _createDatabase);
  }

  // static Future<List<Map<String, dynamic>>> getTaskById(
  //     String tbId, String id) async {
  //   var dbClient = await _openDatabase();
  //   var query = await dbClient.rawQuery(
  //       "SELECT * FROM tasks WHERE taskChildId = '$id' and taskId = '$tbId'");
  //   return query;
  // }

  static getListTask(String idtask) async {
    var dbClient = await _openDatabase();
    var query = await dbClient
        .rawQuery("SELECT * FROM $_tableName WHERE taskId = '$idtask'");
    return query;
  }

  static Future<void> changeStatus(
      String id, String taskChildId, int status, String time) async {
    Database db = await _openDatabase();
    db.rawUpdate(
        "UPDATE $_tableName SET status = $status, completeTime = '$time' WHERE taskId = '$id' and taskChildId = $taskChildId");
  }

  static checkTaskId(String id, String taskChildId) async {
    Database db = await _openDatabase();
    var query = await db.rawQuery(
        "SELECT * FROM $_tableName WHERE taskId = '$id' and taskChildId = $taskChildId");
    return query;
  }

  static Future<void> deleteTask(String id, String taskId) async {
    Database db = await _openDatabase();
    await db.rawDelete(
        "DELETE FROM $_tableName WHERE taskId = '$id' and taskChildId = '$taskId'");
  }
  // static Future<List<Map<String, dynamic>>> searchProductRelative(
  //     String id) async {
  //   var dbClient = await _openDatabase();
  //   var query = await dbClient
  //       .rawQuery("SELECT * FROM $_tableName WHERE productId like '%$id%'");
  //   return query;
  // }
  // static getId(int number) async {
  //   var dbClient = await _openDatabase();
  //   var query = await dbClient.rawQuery(
  //       "SELECT productId FROM $_tableName ORDER BY productId LIMIT 1 ");
  //   return query.toString();
  // }
  // static Future<void> changeName(String id, String name) async {
  //   Database db = await _openDatabase();
  //   db.rawUpdate(
  //       "UPDATE $_tableName SET productName = '$name' WHERE productId = '$id'");
  // }
  // static Future<void> changePrice(String id, int price) async {
  //   Database db = await _openDatabase();
  //   db.rawUpdate(
  //       "UPDATE $_tableName SET price = '$price' WHERE productId = '$id'");
  // }
  // static Future<void> changeImage(String id, String image) async {
  //   Database db = await _openDatabase();
  //   db.rawUpdate(
  //       "UPDATE $_tableName SET image = '$image' WHERE productId = '$id'");
  // }
  // static Future<void> changeQuantity(String id, int quantity) async {
  //   Database db = await _openDatabase();
  //   db.rawUpdate(
  //       "UPDATE $_tableName SET quantity = $quantity + (SELECT quantity FROM $_tableName WHERE productId = '$id') and quantityTemp = $quantity + (SELECT quantityTemp FROM $_tableName WHERE productId = '$id') WHERE productId = '$id'");
  // }
  // static Future<void> changeSale(String id, String sale) async {
  //   Database db = await _openDatabase();
  //   db.rawUpdate(
  //       "UPDATE $_tableName SET sale = '$sale' WHERE productId = '$id'");
  // }
  // static Future<void> changePrSale(String id, int prSale) async {
  //   Database db = await _openDatabase();
  //   db.rawUpdate(
  //       "UPDATE $_tableName SET prSale = '$prSale' WHERE productId = '$id'");
  // }
  // static Future<void> changeQuantityTemp(String id, int temp) async {
  //   Database db = await _openDatabase();
  //   db.rawUpdate(
  //       "UPDATE $_tableName SET quantityTemp = '$temp' WHERE productId = '$id'");
  // }
}
