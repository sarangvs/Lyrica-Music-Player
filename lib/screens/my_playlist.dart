import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:musicplayer/Database/playlist_db.dart';
import 'package:musicplayer/Database/playlist_folder_handler.dart';
import 'package:musicplayer/Widgets/custom_appbar.dart';
import 'package:musicplayer/controller/music_controller.dart';
import 'package:musicplayer/screens/playlist_screen.dart';

class Myplaylist extends StatelessWidget {
  Myplaylist({Key? key}) : super(key: key);

  MusicController musicController = Get.put(MusicController());

  dynamic playlistFolderName;
  dynamic songData;
  dynamic playlistID = 0;
  var folderName;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          appBar: AppBar(
            toolbarHeight: 100,
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: const Icon(
              Icons.add,
              color: Colors.black,
            ),
            title: const Text(
              'New Playlist...',
              style: TextStyle(color: Colors.black, fontSize: 18),
            ),
          ),
          onTap: () {
            _displayTextInputDialog(playlistID, context);
          },
        ),
        body: Stack(
          children: [
            GetBuilder<MusicController>(
              builder: (GetxController controller) {
                return FutureBuilder(
                    future: musicController.playlistHandler.retrievePlaylist(),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<PlaylistFolder>> snapshot) {
                      if (snapshot.hasData) {
                        return ListView.separated(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            playlistID = snapshot.data![index].id!;
                            return Container(
                              padding: const EdgeInsets.all(6),
                              child: Stack(
                                children: [
                                  GestureDetector(
                                    onLongPress: () {
                                      showDialog<void>(
                                        context: context,
                                        barrierDismissible: false,
                                        // user must tap button!
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            backgroundColor: Colors.white,
                                            title: const Text(
                                              'Are you sure to'
                                              ' delete this playlist?',
                                              style: TextStyle(
                                                color: Colors.black54,
                                              ),
                                            ),
                                            actions: <Widget>[
                                              TextButton(
                                                child: const Text('Yes',
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        color: Colors.black54)),
                                                onPressed: () async {
                                                  await musicController
                                                      .playlistHandler
                                                      .deletePlaylist(snapshot
                                                          .data![index].id!);

                                                  snapshot.data!.remove(
                                                      snapshot.data![index]);
                                                  controller.update();
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                              TextButton(
                                                child: const Text(
                                                  'No',
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      color: Colors.black54),
                                                ),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    child: Column(
                                      children: [
                                        ListTile(
                                          leading: const Image(
                                              image: AssetImage(
                                                  'images/liked-songs.png')),
                                          title: Text(
                                            snapshot.data![index].playListName,
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 20,
                                            ),
                                          ),
                                          onTap: () {
                                            playlistID =
                                                snapshot.data![index].id;
                                            musicController.update();
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      PlaylistScreen(
                                                    playlistfolderID:
                                                        playlistID,
                                                  ),
                                                ));
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return const SizedBox(
                              height: 5,
                            );
                          },
                        );
                      }
                      return Container();
                    });
              },
            )
          ],
        ),
      ),
    );
  }

  Future<void> _displayTextInputDialog(playlistID, context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GetBuilder<MusicController>(builder: (controller) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  title: const Text(
                    'New Playlist',
                    style: TextStyle(
                        fontFamily: 'Roboto', fontWeight: FontWeight.bold),
                  ),
                  content: TextField(
                    onChanged: (value) {
                      folderName = musicController.textFieldController.text;
                      controller.update();
                    },
                    controller: musicController.textFieldController,
                    decoration: const InputDecoration(),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        folderName = musicController.textFieldController.text;

                        playlistFolderName = folderName;
                        musicController.addPlaylist(playlistFolderName);
                        musicController.textFieldController.clear();
                        controller.update();
                      },
                      child: const Text('Done',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                    )
                  ],
                );
              })
            ],
          );
        });
  }
}
