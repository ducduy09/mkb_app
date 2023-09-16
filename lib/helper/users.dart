
import 'package:sqflite/sqflite.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
// import 'package:http/http.dart' as http;
//import 'package:mkb_technology/models/user_login.dart';

class UserHelper {

  static const String _tableName = "userLogin";
  static int check = 0;
  static int status = 1;
  
  static Future<void> _createDatabase(Database db, int version) async {
      await db.execute(
        'CREATE TABLE IF NOT EXISTS userLogin(userId INTEGER PRIMARY KEY AUTOINCREMENT,userName TEXT,email TEXT,password TEXT, type Text, status integer, level integer)'
        );
    }
  // Future<int> insertUser(UserLogin user) async {
  //   int userId = 0;
  //   Database db = await getDataBase();
  //   await db.insert( _tableName, user.toMap()).then((value) {
  //     userId = value;
  //   });
  //   return userId;
  // }
  static Future<int> insertUser(String userName, String email, String password, String type, {int? level}) async {
    final db = await _openDatabase();
    final data = {
      'userName': userName,
      'email': email,
      'password': password,
      'type': type,
      'status': 1,
      'level': level ?? 0
    };
    return await db.insert('userLogin', data);
  }
  static Future<List<Map<String, dynamic>>> getData() async {
    final db = await _openDatabase();
    return await db.query('userLogin');
  }
  static Future<Database> _openDatabase() async {
    final databasePath  = await getDatabasesPath();
    final path = join(databasePath, 'MkbTech.db');
    return openDatabase(path, version: 1,onCreate: _createDatabase);
  }
  static checkLogin(String email, String password, String type) async {  
    var dbClient = await _openDatabase();  
    var res = await dbClient.rawQuery("SELECT * FROM $_tableName WHERE email = '$email' and password = '$password' and type = '$type' and status = 1");
    check = res.length;
    if(check == 0){
      var sql = await dbClient.rawQuery("SELECT * FROM $_tableName WHERE email = '$email' and password = '$password' and type = '$type'");
      if(sql.length == 1){
        status = 0;
      }
    }
  } 
  static Future<List<Map<String, dynamic>>> getDataByEmail(String email) async {  
    var dbClient = await _openDatabase();    
    var query = await dbClient.rawQuery("SELECT * FROM $_tableName WHERE email = '$email'");  
    return query;
  }
  static Future<List<Map<String, dynamic>>> getDataByType(String type) async {  
    var dbClient = await _openDatabase();    
    var query = await dbClient.rawQuery("SELECT * FROM $_tableName WHERE type='$type'");  
    return query;
  }
  static Future<void> deleteUser(var a, int b) async {
    Database db = await _openDatabase();
    if(b == 1){
      int userId = a;
      await db.rawDelete("DELETE FROM $_tableName WHERE userId = $userId");
    }
    if(b == 2){
      String email = a;
      await db.rawDelete("DELETE FROM $_tableName WHERE email = '$email'");
    }else{    
      db.query('userLogin');
    }
  }
  static Future<void> updateAllById(int userId, String name, String password, String email) async {
    Database db = await _openDatabase();
    db.rawUpdate("UPDATE $_tableName SET userName = '$name', password = '$password', email = '$email' WHERE userId = '$userId'");
  }
  static getId() async {
    var dbClient = await _openDatabase();
    var query = await dbClient.rawQuery(
        "SELECT userId FROM $_tableName ORDER BY userId LIMIT 1 ");
    return query.toString();
  }
  static Future<void> changePass(String email, String password) async {
    Database db = await _openDatabase();
    db.rawUpdate("UPDATE $_tableName SET password = '$password' WHERE email = '$email'");
  }
  static Future<void> upLevel(int id, int levelOld) async {
    Database db = await _openDatabase();
    db.rawUpdate("UPDATE $_tableName SET level = $levelOld + 1 WHERE userId = '$id'");
  }
  static Future<void> downLevel(int id, int levelOld) async {
    Database db = await _openDatabase();
    db.rawUpdate("UPDATE $_tableName SET level = $levelOld-1 WHERE userId = '$id'");
  }
  static Future<void> changeName(String userId, String name) async {
    Database db = await _openDatabase();
    db.rawUpdate("UPDATE $_tableName SET userName = '$name' WHERE userId = '$userId'");
  }
  static Future<void> bannedAccount(int userId) async {
    Database db = await _openDatabase();
    db.rawUpdate("UPDATE $_tableName SET status = 0 WHERE userId = '$userId'");
  }
  static Future<void> unBlockAccount(int userId) async {
    Database db = await _openDatabase();
    db.rawUpdate("UPDATE $_tableName SET status = 1 WHERE userId = '$userId'");
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