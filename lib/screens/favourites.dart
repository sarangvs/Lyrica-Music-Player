import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musicplayer/Database/db.dart';
import 'package:musicplayer/controller/music_controller.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'fav_playscrenn.dart';

class Favourites extends StatelessWidget {
  Favourites({Key? key}) : super(key: key);

  ///GETX CONTROLLER
  MusicController musicController = Get.put(MusicController());

  @override
  final GlobalKey<FavPlayScreenState> key = GlobalKey<FavPlayScreenState>();

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            GetBuilder<MusicController>(
              builder: (controller) {
                return FutureBuilder(
                  future: musicController.handler!.retrieveUsers(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<User>> snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        itemCount: snapshot.data?.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Dismissible(
                            direction: DismissDirection.endToStart,
                            background: Container(
                              color: Colors.red,
                              alignment: Alignment.centerRight,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: const Icon(Icons.delete_forever),
                            ),
                            key: ValueKey<int>(snapshot.data![index].num),
                            onDismissed: (DismissDirection direction) async {
                              await musicController.handler!
                                  .deleteUser(snapshot.data![index].num);
                              snapshot.data!.remove(snapshot.data![index]);
                              controller.update();
                            },
                            child: ListTile(
                              title: Text(
                                snapshot.data![index].name,
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: Text(
                                snapshot.data![index].name,
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
                                id: snapshot.data![index].num,
                                type: ArtworkType.AUDIO,
                                nullArtworkWidget: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.blueGrey),
                                  child: const Image(
                                    image: AssetImage('images/musicimage.png'),
                                  ),
                                ),
                              ),
                              onTap: () {
                                for (int i = 0;
                                    i < musicController.songs.length;
                                    i++) {
                                  if (musicController.songs[i].id ==
                                      snapshot.data![index].num) {
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
                                        changeTrack: changeFavTrack,
                                        key: key,
                                      ),
                                    ));
                              },
                            ),
                          );
                        },
                      );
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void changeFavTrack(bool isNext) {
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
