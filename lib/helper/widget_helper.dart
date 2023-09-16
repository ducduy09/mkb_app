import 'package:sqflite/sqflite.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
// import 'package:http/http.dart' as http;
//import 'package:mkb_technology/models/user_login.dart';

class WidgetHelper {

  static const String _tableName = "widgets";
  static int check = 0;
  
  static Future<void> _createDatabase(Database db, int version) async {
      await db.execute(
        'CREATE TABLE IF NOT EXISTS widgets(widgetId TEXT, title TEXT,productId TEXT,type TEXT, content Text, primary key(widgetId, productId, type))'
        );
    }
  static Future<int> insertWidget(String widgetId, String title, String productId, String type, String content) async {
    final db = await _openDatabase();
    final data = {
      'widgetId': widgetId,
      'title': title,
      'productId': productId,
      'type': type,
      'content': content
    };
    return await db.insert('widgets', data);
  }
  static Future<List<Map<String, dynamic>>> getData() async {
    final db = await _openDatabase();
    return await db.query('widgets');
  }
  static Future<Database> _openDatabase() async {
    final databasePath  = await getDatabasesPath();
    final path = join(databasePath, 'MkbTech.db');
    return openDatabase(path, version: 1,onCreate: _createDatabase);
  }
  // static checkLogin(String email, String password, String type) async {  
  //   var dbClient = await _openDatabase();  
  //   var res = await dbClient.rawQuery("SELECT * FROM $_tableName WHERE email = '$email' and password = '$password' and type = '$type'");
  //   check = res.length;
  // } 
  static Future<List<Map<String, dynamic>>> getDataById(String id) async {  
    var dbClient = await _openDatabase();    
    var query = await dbClient.rawQuery("SELECT * FROM $_tableName WHERE widgetId = '$id'");  
    return query;
  }
  static Future<List<Map<String, dynamic>>> getDataByType(String type) async {  
    var dbClient = await _openDatabase();    
    var query = await dbClient.rawQuery("SELECT * FROM $_tableName WHERE type='$type'");  
    return query;
  }
  static Future<void> deleteProductWidget(String wid, String pid, String type) async {
    Database db = await _openDatabase();
    await db.rawDelete("DELETE FROM $_tableName WHERE widgetId = '$wid' and productId = '$pid' and type = '$type'");
  }
  static Future<void> deleteByWidget(String wid) async {
    Database db = await _openDatabase();
     await db.rawDelete("DELETE FROM $_tableName WHERE widgetId = '$wid'");
  }
  static Future<void> deleteAllType(String type) async {
    Database db = await _openDatabase();
     await db.rawDelete("DELETE FROM $_tableName WHERE type = '$type'");
  }

  static Future<void> changeTitle(String title, String wid, String pid, String type) async {
    Database db = await _openDatabase();
    db.rawUpdate("UPDATE $_tableName SET title = '$title' WHERE widgetId = '$wid' and productId = '$pid' and type = '$type'");
  }
  static Future<void> changeContent(String content, String wid, String pid, String type) async {
    Database db = await _openDatabase();
    db.rawUpdate("UPDATE $_tableName SET content = '$content' WHERE widgetId = '$wid' and productId = '$pid' and type = '$type'");
  }
  // Future<UserLogin> getUser(int userId)async{
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