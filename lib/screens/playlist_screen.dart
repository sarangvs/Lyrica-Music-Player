import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musicplayer/Database/playlist_songs.dart';
import 'package:musicplayer/controller/music_controller.dart';
import 'package:musicplayer/screens/fav_playscrenn.dart';
import 'package:musicplayer/screens/select_playlist_track.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../Database/playlist_folder_handler.dart';
import 'package:get/get.dart';

class PlaylistScreen extends StatelessWidget {
  dynamic playlistfolderID;

  PlaylistScreen({Key? key, required this.playlistfolderID}) : super(key: key);

  MusicController musicController = Get.put(MusicController());

  @override
  final GlobalKey<FavPlayScreenState> key = GlobalKey<FavPlayScreenState>();

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 30,
            right: 0,
            height: screenHeight / 8,
            child: const Text(
              'Songs',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          Positioned(
            top: 0,
            left: screenWidth - 40,
            right: 0,
            height: screenHeight / 26,
            child: InkWell(
              child: const Icon(Icons.playlist_add),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SelectPlaylistSongs(
                        playlistiddd: playlistfolderID,
                      ),
                    ));
                debugPrint('playlist button clicked');
              },
            ),
          ),
          Positioned(
            top: 28,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Container(
                height: screenHeight,
                width: screenWidth,
                child: GetBuilder<MusicController>(
                  builder: (controller) {
                    return FutureBuilder(
                      future: musicController.playlistDatabaseHandler!
                          .retrieveSongs(playlistfolderID),
                      builder: (BuildContext context,
                          AsyncSnapshot<List<PlaylistSongs>> snapshot) {
                        if (snapshot.hasData) {
                          return ListView.builder(
                            itemCount: snapshot.data?.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Dismissible(
                                direction: DismissDirection.endToStart,
                                background: Container(
                                  color: Colors.red,
                                  alignment: Alignment.centerRight,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  child: const Icon(Icons.delete_forever),
                                ),
                                key: ValueKey<int>(snapshot.data![index].id!),
                                onDismissed:
                                    (DismissDirection direction) async {
                                  await musicController.playlistDatabaseHandler!
                                      .deleteSongs(snapshot.data![index].id!);

                                  snapshot.data!.remove(snapshot.data![index]);
                                  controller.update();
                                },
                                child: ListTile(
                                  title: Text(
                                    snapshot.data![index].path,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  subtitle: Text(
                                    snapshot.data![index].path,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  trailing: SizedBox(
                                    height: screenHeight / 7,
                                    width: screenWidth / 7,
                                    child: const Icon(
                                      Icons.play_arrow_rounded,
                                      color: Colors.orange,
                                      size: 42,
                                    ),
                                  ),
                                  leading: QueryArtworkWidget(
                                    artworkBorder: BorderRadius.circular(10),
                                    id: snapshot.data![index].songID,
                                    type: ArtworkType.AUDIO,
                                    nullArtworkWidget: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.blueGrey),
                                      child: const Image(
                                        image:
                                            AssetImage('images/musicimage.png'),
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    for (int i = 0;
                                        i < musicController.songs.length;
                                        i++) {
                                      if (musicController.songs[i].id ==
                                          snapshot.data![index].songID) {
                                        musicController.currentIndex = i;
                                        break;
                                      }
                                    }
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => FavPlayScreen(
                                            songData: musicController.songs[
                                                musicController.currentIndex],
                                            changeTrack: changeTrack,
                                            key: key,
                                          ),
                                        ));
                                  },
                                ),
                              );
                            },
                          );
                        } else {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                      },
                    );
                  },
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void changeTrack(bool isNext) {
    if (isNext) {
      if (musicController.currentIndex != musicController.songs.length - 1) {
        musicController.currentIndex++;
      }
    } else {
      if (musicController.currentIndex != 0) {
        musicController.currentIndex--;
      }
    }
    key.currentState!
        .setSong(musicController.songs[musicController.currentIndex]);
  }
}
