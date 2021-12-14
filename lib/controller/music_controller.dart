
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musicplayer/Database/database_handler.dart';
import 'package:musicplayer/Database/playlist_db.dart';
import 'package:musicplayer/Database/playlist_folder_handler.dart';
import 'package:musicplayer/Database/playlist_songs.dart';
import 'package:musicplayer/screens/fav_playscrenn.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../screens/play_screen.dart';


class MusicController extends GetxController {
  ///key of songscreen
  final GlobalKey<PlayScreenState> Key = GlobalKey<PlayScreenState>();
  ///key of Fav screen
  final GlobalKey<FavPlayScreenState> key = GlobalKey<FavPlayScreenState>();
  ///key of playlist screen
  final GlobalKey<FavPlayScreenState> keypl = GlobalKey<FavPlayScreenState>();



  ///Instance of database handler favorites
  DatabaseHandler? handler;
  ///playlist handler
  late PlaylistDatabaseHandler playlistHandler;
///playlist add songs
  late PlaylistDatabaseHandler playlistSongHandler;
///playlist songs
  PlaylistDatabaseHandler? playlistDatabaseHandler;


  @override
  void onInit() {
    super.onInit();
    player = AudioPlayer();
    getTracks();
    requestPermission();
    handler = DatabaseHandler();
    playlistHandler = PlaylistDatabaseHandler();
    playlistSongHandler = PlaylistDatabaseHandler();
    playlistDatabaseHandler= PlaylistDatabaseHandler();
  }

  @override
  void onClose() {
    super.onClose();
  }

  ///INITIALIZING AUDIO QUERY
  final OnAudioQuery audioQuery = OnAudioQuery();

  ///INITIALIZING JUST AUDIO
  late AudioPlayer player;

  ///LIST FOR ADDING SONGS
  List<SongModel> songs = [];

  ///CURRENT INDEX OF SONGS
  int currentIndex = 0;

  ///playlist folder text editing controller
  final TextEditingController textFieldController = TextEditingController();



  ///PERMISSION FOR ACCESSING AUDIO FILES IN DEVICE
  void requestPermission() async {
    // Web platform don't support permissions methods.
    if (!kIsWeb) {
      final bool permissionStatus = await audioQuery.permissionsStatus();
      if (!permissionStatus) {
        await audioQuery.permissionsRequest();
      }
      update();
    }
  }

  ///Querying songs from audio query and storing in a list
  void getTracks() async {
    songs = await audioQuery.querySongs();
    songs = songs;
    update();
  }

  ///Function for changing the track
  void changeTrack(bool isNext) {
    if (isNext) {
      if (currentIndex != songs.length - 1) {
        currentIndex++;
      }
    } else {
      if (currentIndex != 0) {
        currentIndex--;
      }
    }
    Key.currentState!.setSong(songs[currentIndex]);
  }

  ///change fav songs
  void changeFavTrack(bool isNext) {
    if (isNext) {
      if (currentIndex != songs.length - 1) {
        currentIndex++;
      }
    } else {
      if (currentIndex!= 0) {
       currentIndex--;
      }
    }
    key.currentState!.setSong(songs[currentIndex]);
  }

  ///change next screen
  void changeTrackplaylist(bool isNext) {
    if (isNext) {
      if (currentIndex != songs.length - 1) {
        currentIndex++;
      }
    } else {
      if (currentIndex != 0) {
        currentIndex--;
      }
    }
    key.currentState!.setSong(songs[currentIndex]);
  }




  ///settings page
  void launchURLBrowser() async {
    const url = 'https://github.com/sarangvs/privacy-policy/blob/main/privacy-policy.md';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void rateApp() async {
    const url = 'https://play.google.com/store/apps/details?id=com.sarangvs.musicplayer';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
///playlist folder
  Future<int> addPlaylist(playlistFolderName) async {
    final PlaylistFolder firstUser =
    PlaylistFolder(playListName: playlistFolderName);
    final List<PlaylistFolder> listOfUsers = [firstUser];
    return await playlistHandler.insertPlaylist(listOfUsers);
  }

  ///Playlist add screen
  Future<int> addUsers(songID_2, playlistID_2, path_2, songName_2) async {
    final PlaylistSongs firstUser = PlaylistSongs(
        path: path_2,
        songName: songName_2,
        songID: songID_2,
        playlistID: playlistID_2);
    final List<PlaylistSongs> listOfUsers = [firstUser];
    return await playlistSongHandler.insertSongs(listOfUsers);
  }

  ///playscreen





}
