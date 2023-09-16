// ignore_for_file: file_names

import 'package:sqflite/sqflite.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
// import 'dart:io' as io;

class DatabaseHelper {
  
  static Future<Database> _openDatabase() async {
    final databasePath  = await getDatabasesPath();
    final path = join(databasePath, 'MkbTech.db');
    return openDatabase(path, version: 1,onCreate: _createDatabase);
  }
  
  static Future<void> _createDatabase(Database db, int version) async {
      await db.execute(
        'Create table if not exists users(id integer primary key autoincrement, avatar text, name text, age integer, address text, wallet integer)');
    }
    
  static Future<int> insertUser(int id, String avatar, String name, int age, String address, int wallet) async {
    final db = await _openDatabase();
    final data = {
      'id': id,
      'avatar': avatar,
      'name': name,
      'age': age,
      'address': address,
      'wallet': wallet
    };
    return await db.insert('users', data);
  }
  static Future<void> deleteUser(int userId) async {
    Database db = await _openDatabase();
    await db.rawDelete("DELETE FROM users WHERE id = $userId");
  }
  static Future<List<Map<String, dynamic>>> getData() async {
    final db = await _openDatabase();
    return await db.query('users');
  }
  static Future<void> updateAllById(int id, String name, String age, String address, String avt) async {
    Database db = await _openDatabase();
    db.rawUpdate("UPDATE users SET name = '$name', age = '$age', address = '$address', avatar = '$avt' WHERE id = '$id'");
  }
  static Future<void> recharge(int id, int money) async {
    Database db = await _openDatabase();
    var wallet = await db.rawQuery("select wallet from users where id = '$id'");
    int mn = int.parse(wallet[0]["wallet"].toString());  
    db.rawUpdate("UPDATE users SET wallet = $mn + $money WHERE id = '$id'");
  }
  static Future<int> payment(int id, int money) async {
    Database db = await _openDatabase();
    var wallet = await db.rawQuery("select wallet from users where id = '$id'");
    int mn = int.parse(wallet[0]["wallet"].toString());  
    if(mn > money){
      db.rawUpdate("UPDATE users SET wallet = $mn - $money WHERE id = '$id'");
      return 0;
    }else{
      return 1;
    }
  }
  static Future<List<Map<String, dynamic>>> getDataById(int id) async {  
    var dbClient = await _openDatabase();    
    var query = await dbClient.rawQuery("SELECT * FROM users WHERE id = '$id'");  
    return query;
  }
}