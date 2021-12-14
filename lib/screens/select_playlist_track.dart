import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musicplayer/controller/music_controller.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SelectPlaylistSongs extends StatefulWidget {
  int playlistiddd;

  SelectPlaylistSongs({Key? key, required this.playlistiddd}) : super(key: key);

  @override
  _SelectPlaylistSongsState createState() => _SelectPlaylistSongsState();
}

class _SelectPlaylistSongsState extends State<SelectPlaylistSongs> {
  MusicController musicController = Get.put(MusicController());

  int? songID_2;
  int? playlistID_2;
  String? songName_2;
  String? path_2;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          'Select Songs',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: FutureBuilder<List<SongModel>>(
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
                          child: IconButton(
                            icon: const Icon(Icons.add_circle_outline),
                            //   : const Icon(
                            // Icons.check,
                            // color: Colors.orange,

                            onPressed: () {
                              setState(() {
                                songID_2 = musicController.songs[index].id;
                                playlistID_2 = widget.playlistiddd;
                                songName_2 = musicController.songs[index].title;
                                path_2 = musicController.songs[index].data;
                                musicController.addUsers(
                                    songID_2, playlistID_2, songName_2, path_2);
                                showToast();
                                // add == 0 ? add = 1 : add = 0;
                              });
                            },
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
    ));
  }

  void showToast() {
    Fluttertoast.showToast(
        msg: 'Song added to playlist',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black87,
        textColor: Colors.white,
        fontSize: 15.0);
  }
}
