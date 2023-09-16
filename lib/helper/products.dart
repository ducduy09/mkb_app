//import 'package:mkb_technology/models/products.dart';

// ignore_for_file: avoid_print

import 'package:sqflite/sqflite.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
//import 'package:mkb_technology/models/user_login.dart';

class ProductHelper {
  // ignore: prefer_final_fields
  static String _tableName = "products";
  static Future<void> _createDatabase(Database db, int version) async {
    await db.execute(
        'CREATE TABLE IF NOT EXISTS $_tableName(productId TEXT PRIMARY KEY, productName TEXT, productImage TEXT, price integer, quantity integer, sale TEXT, prSale integer)');
  }

  static Future<int> insertProduct(
      String productId,
      String productName,
      String productImage,
      int price,
      int quantity,
      String sale,
      int prSale) async {
    final db = await _openDatabase();
    final data = {
      'productId': productId,
      'productName': productName,
      'productImage': productImage,
      'price': price,
      'quantity': quantity,
      'sale': sale,
      'prSale': prSale,
      'quantityTemp': quantity,
      'status': 0
      //'warehourseCode': code,
    };
    return await db.insert(_tableName, data);
  }

  static Future<List<Map<String, dynamic>>> getData() async {
    final db = await _openDatabase();
    return await db.query('products');
  }

  static Future<Database> _openDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'MkbTech.db');
    return openDatabase(path, version: 1, onCreate: _createDatabase);
  }

  // static getLastID() async {
  //   String? id;
  //   int lastId = 0;
  //   var dbClient = await _openDatabase();
  //   var query = await dbClient.rawQuery("SELECT productId FROM $_tableName ORDER BY productId DESC LIMIT 1");
  //   id = query.toString();
  //   lastId = int.parse(id.substring(id.length - 1));
  //   print(lastId);
  //   return lastId;
  // }
  static Future<List<Map<String, dynamic>>> getLastID(String id) async {
    var dbClient = await _openDatabase();
    var query = await dbClient.rawQuery(
        "SELECT * FROM products WHERE productId LIKE '$id%' ORDER BY LENGTH(productId) DESC, productId DESC LIMIT 1");
    return query;
  }

  static searchProductByName(String productName) async {
    var dbClient = await _openDatabase();
    var query = await dbClient.rawQuery(
        "SELECT * FROM $_tableName WHERE productName like '%$productName%'");
    return query;
  }

  static Future<List<Map<String, dynamic>>> searchProduct(String id) async {
    var dbClient = await _openDatabase();
    var query = await dbClient
        .rawQuery("SELECT * FROM $_tableName WHERE productId = '$id'");
    // List<dynamic> product = [];
    // product = query;
    // product[1];
    return query;
  }
  static Future<List<Map<String, dynamic>>> searchProductRelative(String id) async {
    var dbClient = await _openDatabase();
    var query = await dbClient
        .rawQuery("SELECT * FROM $_tableName WHERE productId like '%$id%'");
    return query;
  }
  static getId(int number) async {
    var dbClient = await _openDatabase();
    var query = await dbClient.rawQuery(
        "SELECT productId FROM $_tableName ORDER BY productId LIMIT 1 ");
    return query.toString();
  }

  static Future<void> deleteProduct({String? id, String? name}) async {
    Database db = await _openDatabase();
    id != null
        ? await db.rawDelete("DELETE FROM $_tableName WHERE productId = '$id' ")
        : await db.rawDelete("DELETE FROM $_tableName WHERE productName = '$name' ");
  }

  static Future<int> updateAllById(String id, String name, String image,
      int price, int quantity, String sale, int prSale) async {
    Database db = await _openDatabase();
    return db.rawUpdate(
        "UPDATE $_tableName SET productName = '$name', productImage = '$image', price = '$price', sale = '$sale', prSale = '$prSale' WHERE productId = '$id'");
  }

  static Future<void> changeName(String id, String name) async {
    Database db = await _openDatabase();
    db.rawUpdate(
        "UPDATE $_tableName SET productName = '$name' WHERE productId = '$id'");
  }

  static Future<void> changePrice(String id, int price) async {
    Database db = await _openDatabase();
    db.rawUpdate(
        "UPDATE $_tableName SET price = '$price' WHERE productId = '$id'");
  }

  static Future<void> changeStatus(String id, int status) async {
    Database db = await _openDatabase();
    if(status >= 0 && status <= 2) {
      db.rawUpdate(
        "UPDATE $_tableName SET status = '$status' WHERE productId = '$id'");
    }
  }

  static Future<void> changeImage(String id, String image) async {
    Database db = await _openDatabase();
    db.rawUpdate(
        "UPDATE $_tableName SET image = '$image' WHERE productId = '$id'");
  }

  static Future<void> changeQuantity(String id, int quantity) async {
    Database db = await _openDatabase();
    db.rawUpdate(
        "UPDATE $_tableName SET quantity = $quantity + (SELECT quantity FROM $_tableName WHERE productId = '$id') and quantityTemp = $quantity + (SELECT quantityTemp FROM $_tableName WHERE productId = '$id') WHERE productId = '$id'");
  }

  static Future<void> changeSale(String id, String sale) async {
    Database db = await _openDatabase();
    db.rawUpdate(
        "UPDATE $_tableName SET sale = '$sale' WHERE productId = '$id'");
  }

  static Future<void> changePrSale(String id, int prSale) async {
    Database db = await _openDatabase();
    db.rawUpdate(
        "UPDATE $_tableName SET prSale = '$prSale' WHERE productId = '$id'");
  }
  static Future<void> changeQuantityTemp(String id, int temp) async {
    Database db = await _openDatabase();
    db.rawUpdate(
        "UPDATE $_tableName SET quantityTemp = '$temp' WHERE productId = '$id'");
  }
  // Future<UserLogin> getUser(String userId)async{
  //   Database db = await getDataBase();
  //   List<Map<String, dynamic>> user = await db.rawQuery("SELECT * FROM $_tableName WHERE id = $userId");
  //   if(user.length == 1){
  //     return UserLogin(
  //         userId: user[0]["userId"],
  //         userName: user[0]["userName"],
  //         email: user[0]["email"],
  //         password: user[0]["password"]);
  //   } else {
  //     return UserLogin(userId: '', email: '', password: '');
  //   }
  // }
}
