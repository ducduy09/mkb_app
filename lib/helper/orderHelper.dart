// ignore_for_file: file_names

import 'package:sqflite/sqflite.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';

class OrderHelper {
  // ignore: prefer_final_fields
  static String _tableName = "orders";
  static Future<void> _createDatabase(Database db, int version) async {
    await db.execute(
        'CREATE TABLE IF NOT EXISTS $_tableName(tradingCode text primary key, productId TEXT, userId TEXT, price double, address text, quantity integer, complete integer, isCart integer)');
  }

  static Future<int> insertOrder(
      String code,
      String productId,
      String userId,
      double price,
      String address,
      int quantity,
      int complete,
      int isCart,
      {int? isConfirm}) async {
    final db = await _openDatabase();
    if (complete != 0 && complete != 1) {
      return 0;
    } else {
      final data = {
        'tradingCode': code,
        'productId': productId,
        'userId': userId,
        'price': price,
        'address': address,
        'quantity': quantity,
        'complete': complete,
        'isCart': isCart,
        'isConfirm': isConfirm ?? 0
      };
      return await db.insert(_tableName, data);
    }
  }

  static Future<List<Map<String, dynamic>>> getData() async {
    final db = await _openDatabase();
    return await db.query('orders');
  }

  static Future<Database> _openDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'MkbTech.db');
    return openDatabase(path, version: 1, onCreate: _createDatabase);
  }

  static getOrderComplete(String code, int complete) async {
    Database db = await _openDatabase();
    var query = await db.rawQuery(
        "SELECT * FROM $_tableName WHERE userId = '$code' and complete = $complete");
    return query;
  }

  static getDataOrderNew() async {
    var dbClient = await _openDatabase();
    var query = await dbClient.rawQuery("SELECT * FROM $_tableName WHERE complete = 0 and isCart = 0");
    return query;
  }
  static getDataIsCart(String code, int cart) async {
    var dbClient = await _openDatabase();
    var query = await dbClient.rawQuery("SELECT * FROM $_tableName WHERE userId = '$code' and isCart = $cart");
    return query;
  }

  static searchOrderByUser(String userID) async {
    var dbClient = await _openDatabase();
    var query = await dbClient
        .rawQuery("SELECT * FROM $_tableName WHERE UserId = '$userID'");
    return query;
  }

  static searchUserbyProduct(String id) async {
    var dbClient = await _openDatabase();
    var query = await dbClient
        .rawQuery("SELECT * FROM $_tableName WHERE productId = '$id'");
    return query;
  }

  static Future<void> deleteOrder(String code) async {
    Database db = await _openDatabase();
    await db.rawDelete("DELETE FROM $_tableName WHERE tradingCode = '$code'");
  }

  static Future<int> updateOrder(
      String id, String name, double price, int quantity) async {
    Database db = await _openDatabase();
    return db.rawUpdate(
        "UPDATE $_tableName SET price = '$price', quantity = '$quantity' WHERE productId = '$id' and userId = '$name'");
  }

  static Future<int> deleteCart(String code) async {
    Database db = await _openDatabase();
    return db.rawUpdate(
        "UPDATE $_tableName SET isCart = 0 WHERE tradingCode = '$code'");
  }

  static Future<int> addToCart(String code) async {
    Database db = await _openDatabase();
    return db.rawUpdate(
        "UPDATE $_tableName SET isCart = 1 WHERE tradingCode = '$code'");
  }
  static Future<void> changeQuantity(
      String id, String name, int quantity) async {
    Database db = await _openDatabase();
    db.rawUpdate(
        "UPDATE $_tableName SET quantity = '$quantity' WHERE productId = '$id' and userId = '$name'");
  }

  static Future<void> changePrice(String id, String name, int price) async {
    Database db = await _openDatabase();
    db.rawUpdate(
        "UPDATE $_tableName SET price = '$price' WHERE productId = '$id' and userId = '$name'");
  }

  static Future<int> orderComplete(String code, int complete) async {
    Database db = await _openDatabase();
    return db.rawUpdate(
        "UPDATE $_tableName SET complete = '$complete' WHERE tradingCode = '$code'");
  }
}
