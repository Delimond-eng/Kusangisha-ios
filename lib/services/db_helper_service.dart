import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper{
  static Database _db;
  static const String DB_NAME='storage.db';

  static Future<Database> get db async{
    if(_db != null){
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  static initDb() async{
    var dbPath = await getDatabasesPath();
    String path = join(dbPath, DB_NAME);
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  static _onCreate(Database db, int version) async{
    await db.execute("CREATE TABLE Storage (ID INTEGER PRIMARY KEY, KEY TEXT, VALUE TEXT, USERNAME TEXT)");
  }

  static Future saveData(String key, String value, String user) async{

    var dbClient = await db;
    // Insert some records in a transaction
    await dbClient.transaction((txn) async {
      var query = "INSERT INTO storage(KEY, VALUE, USERNAME) VALUES('"+key+"', '"+value+"','"+user+"')";
      int id = await txn.rawInsert(query);
      print('inserted1: $id');
    });
  }

  static Future getAllData() async{
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM storage');
    return list;
  }

  static Future findWhere(String cdt) async{
    var dbClient = await db;
    var query = "SELECT * FROM storage WHERE KEY='"+cdt+"' ";
    return await dbClient.rawQuery(query);
  }

  static Future updateData(int id, String key, String value) async{
    var dbClient = await db;
    int count = await dbClient.rawUpdate(
        'UPDATE storage SET KEY = ?, VALUE = ? WHERE ID = ?',
        ['$key', '$value', '$id']);
    print('updated: $count');
  }

  static Future deleteData(int id) async{
    var dbClient = await db;
    // Delete a record
    int count = await dbClient
        .rawDelete('DELETE FROM storage WHERE ID = ?', ['$id']);
    print(count);
  }



}


