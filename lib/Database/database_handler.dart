import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'db.dart';

class DatabaseHandler {

  Future<Database> initializeDB() async {
    String dbpath = await getDatabasesPath();
    return openDatabase(join(dbpath, "favSongsDb.db"),
      version: 1,
      onCreate: (database, version,) async {
        print("Creating favourite SONG");
        await database.execute(
          "CREATE TABLE users(num INTEGER PRIMARY KEY,name TEXT NOT NULL,location TEXT NOT NULL)",);
      },);
  }

  Future <int> insertUser(List<User>users) async {
    int result = 0;
    final Database db = await initializeDB();
    for (var user in users) {
      result = await db.insert('users', user.toMap());
    }
    return result;
  }


  Future <List<User>> retrieveUsers() async {
    final Database db = await initializeDB();
    final List <Map<String, Object?>>queryResult = await db.query('users');
    debugPrint("Queryresult: $queryResult");
    return queryResult.map((e) => User.fromMap(e)).toList();
  }


  Future<void> deleteUser(int num) async {
    final db = await initializeDB();
    await db.delete(
      'users',
      where: "num = ?",
      whereArgs: [num],
    );
  }


///fetch fav///
  Future <List<String>> retrieveFavUsers() async {
    final Database db = await initializeDB();
    final List <Map<String, Object?>>queryResult = await db.query('users');
    final List<Map<String, Object?>> songNameList =
    await db.rawQuery("SELECT name FROM users");

    final Set<String> songNameSet = {};
    for (int i = 0; i < songNameList.length; i++) {
      final String data = songNameList[i]
          .values
          .toString()
          .substring(1, songNameList[i].values.toString().length - 1);
      songNameSet.add(data);
    }
    final List<String> listSongName = [...songNameSet.toList()];
return listSongName;
  }

}
