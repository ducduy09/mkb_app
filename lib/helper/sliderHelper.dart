// ignore_for_file: file_names

import 'package:sqflite/sqflite.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';

class SliderHelper {
  // ignore: prefer_final_fields
  static String _tableName = "sliders";
  static Future<void> _createDatabase(Database db, int version) async {
    await db.execute(
      'CREATE TABLE IF NOT EXISTS $_tableName(slideId integer PRIMARY KEY AUTOINCREMENT, image_path text)'
    );
  }
  static Future<int> insertSlide(String imagePath) async {
    final db = await _openDatabase();
    final data = {'image_path': imagePath};
    return await db.insert(_tableName, data);
  }
  static Future<List<Map<String, dynamic>>> getData() async {
    final db = await _openDatabase();
    return await db.query(_tableName);
  }
  static Future<Database> _openDatabase() async {
    final databasePath  = await getDatabasesPath();
    final path = join(databasePath, 'MkbTech.db');
    return openDatabase(path, version: 1,onCreate: _createDatabase);
  }
  static Future<void> deleteSlide(int id) async {
    Database db = await _openDatabase();
    await db.rawDelete("DELETE FROM $_tableName WHERE slideId = '$id'");
  }                            
  static Future<int> updateSlide(int id, String path) async {
    Database db = await _openDatabase();
    return db.rawUpdate(
      "UPDATE $_tableName SET image_path = '$path' WHERE slideId = '$id'");
  }
}