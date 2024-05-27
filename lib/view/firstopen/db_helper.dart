import 'dart:convert';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper{
  final int version = 1;
  Database? db;

  Future<Database?> openDB() async{
    if(db == null){
      db = await openDatabase(join(await getDatabasesPath(), "settings.db"), onCreate: (database, version){
        database.execute("CREATE TABLE settings(id INTEGER PRIMARY KEY, theme TEXT)");
      }, version: version);
    }
    print("Initialisation de la base");
    return db;
  }

  Future<void> savedSettings() async{
    if(await countSettings() == 0){
      await db!.execute("INSERT INTO settings VALUES(0,'light')");
    }
  }

  Future<int> countSettings() async{
    db = await openDB();
    print("Path: ${db!.path}");
    List count =await db!.rawQuery("SELECT count(*) as count FROM settings");
    Map<String, dynamic> settings = count[0] as Map<String, dynamic>;
    int number = settings["count"];
    print("Number of settings: $number");
    return number;
  }

}