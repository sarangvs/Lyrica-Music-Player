import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:musicplayer/controller/music_controller.dart';
import 'package:musicplayer/screens/play_screen.dart';
import 'package:on_audio_query/on_audio_query.dart';

class Songscreen extends StatefulWidget {
  const Songscreen({Key? key}) : super(key: key);

  @override
  _SongscreenState createState() => _SongscreenState();
}

MusicController musicController = Get.put(MusicController());

class _SongscreenState extends State<Songscreen> {
  ///GETX CONTROLLER

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
      body: Stack(
        children: [
          Center(
            child: FutureBuilder<List<SongModel>>(
              future: musicController.audioQuery.querySongs(
                sortType: SongSortType.DISPLAY_NAME,
                orderType: OrderType.ASC_OR_SMALLER,
                uriType: UriType.EXTERNAL,
                ignoreCase: true,
              ),
              builder: (context, item) {
                if (item.data == null) {
                  return const CircularProgressIndicator();
                }
                if (item.data!.isEmpty) {
                  return const Text('Nothing found!');
                }

                return ListView.builder(
                  itemCount: musicController.songs.length,
                  itemBuilder: (context, index) {
                    if (musicController.songs[index].data.contains('mp3')) {
                      return Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              musicController.currentIndex = index;

                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PlayScreen(
                                      changeTrack: musicController.changeTrack,
                                      songInfo: musicController
                                          .songs[musicController.currentIndex],
                                      key: musicController.Key,
                                      //TODO : GLOBAL KEY
                                    ),
                                  ));
                            },
                            child: ListTile(
                              title: Text(
                                musicController.songs[index].title,
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: Text(
                                musicController.songs[index].artist ??
                                    'Unknown Artist',
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
                                id: musicController.songs[index].id,
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
                            ),
                          ),
                          const Divider(
                            height: 0,
                            indent: 5,
                          )
                        ],
                      );
                    }
                    return Container(
                      height: 0,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    ));
  }
}
