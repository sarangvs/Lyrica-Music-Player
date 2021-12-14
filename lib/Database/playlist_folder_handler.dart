import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/material.dart';
import './playlist_songs.dart';
import './playlist_db.dart';

class PlaylistDatabaseHandler {
  Future<Database> initializeDB() async {
    final String dbpath = await getDatabasesPath();
    return openDatabase(
      join(dbpath, 'playlistsDB.db'),
      version: 1,
      onCreate: (
        database,
        version,
      ) async {
        print('Create playlist');
        await database.execute(
          'CREATE TABLE playlist(id INTEGER PRIMARY KEY AUTOINCREMENT,'
          'playListName TEXT NOT NULL)',
        );
        await database.execute(
          'CREATE TABLE songs(id INTEGER PRIMARY KEY AUTOINCREMENT,'
          'songID INTEGER NOT NULL,playlistID INTEGER NOT NULL,'
          'songName TEXT NOT NULL,path TEXT)',
        );
      },
    );
  }

  Future<int> insertPlaylist(List<PlaylistFolder> playlist) async {
    int result = 0;
    final Database db = await initializeDB();
    for (var element in playlist) {
      result = await db.insert('playlist', element.toMapForDB());
      print('Playlist result:$result');
    }
    return result;
  }

  Future<int> insertSongs(List<PlaylistSongs> songs) async {
    int result = 0;
    final Database db = await initializeDB();
    for (var song in songs) {
      result = await db.insert('songs', song.toMapForDB());
      print(
          'Playlistsongresultssssssssssssssssssssssssssssssssssssssss:$result');
    }
    return result;
  }

  Future<List<PlaylistFolder>> retrievePlaylist() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.query('playlist');
    return queryResult.map((e) => PlaylistFolder.fromMap(e)).toList();
  }

  Future<List<PlaylistSongs>> retrieveSongs(int playlistfolderID) async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult =
        await db.query('songs', where: 'playlistID=="$playlistfolderID"');
    return queryResult.map((e) => PlaylistSongs.fromMap(e)).toList();
  }

  Future<void> deletePlaylist(int id) async {
    final db = await initializeDB();
    await db.delete(
      'playlist',
      where: 'id = ?',
      whereArgs: [id],
    );
    debugPrint('PLAYLIST DELETED');
  }

  Future<void> deleteSongs(int id) async {
    final db = await initializeDB();
    await db.delete(
      'songs',
      where: 'id = ?',
      whereArgs: [id],
    );
    debugPrint('song deleted');
  }
}
