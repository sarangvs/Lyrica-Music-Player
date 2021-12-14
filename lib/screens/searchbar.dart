import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musicplayer/screens/play_screen.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SearchBar extends StatefulWidget {
  const SearchBar({Key? key}) : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  late final AudioPlayer player;
  final OnAudioQuery _audioQuery = OnAudioQuery();
  List<SongModel> _foundSongs = [];
  List<SongModel> songs = [];
  int currentIndex = 0;
  final GlobalKey<PlayScreenState> key = GlobalKey<PlayScreenState>();

  @override
  void initState() {
    super.initState();
    getTracks();
    requestPermission();
  }

  void requestPermission() async {
    if (!kIsWeb) {
      final bool permissionStatus = await _audioQuery.permissionsStatus();
      if (!permissionStatus) {
        await _audioQuery.permissionsRequest();
      }
      //setState(() {});
    }
  }

  void getTracks() async {
    songs = await _audioQuery.querySongs();
    setState(() {
      songs = songs;
    });
  }

  void _runFilter(String enteredKeyword) {
    List<SongModel> results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space,
      // we'll display all users
      results = songs;
    } else {
      results = songs
          .where((user) =>
              user.title.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
      // we use the toLowerCase() method to make it case-insensitive
    }

    // Refresh the UI
    setState(() {
      _foundSongs = results;
    });
  }


  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
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
        title: TextFormField(
            onChanged: (value) => _runFilter(value),
            style: const TextStyle(color: Colors.black, fontSize: 20),
// cursorHeight: 30,
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.transparent,
                  ),
                ),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                hintText: 'Search',
                hintStyle: TextStyle(fontSize: 20, color: Colors.grey))),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: _foundSongs.isNotEmpty
                ? ListView.builder(
                    itemCount: _foundSongs.length,
                    itemBuilder: (context, index) => Column(
                      children: [
                        ListTile(
                          onTap: () {
                            player.setUrl(songs[index].data);
                            player.play();
                          },
                          leading: QueryArtworkWidget(
                            artworkBorder: BorderRadius.circular(8),
                            nullArtworkWidget: Container(
                                width: screenWidth / 8,
                                height: screenHeight / 14,
                                decoration: BoxDecoration(
                                    color: Colors.blueGrey,
                                    borderRadius: BorderRadius.circular(10)),
                                child: const Icon(
                                  Icons.audiotrack,
                                  color: Colors.white,
                                  size: 20,
                                )),
                            id: songs[index].id,
                            type: ArtworkType.AUDIO,
                            artworkFit: BoxFit.contain,
                          ),
                          title: Text(
                            _foundSongs[index].title,
                            style: const TextStyle(color: Colors.black),
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            '${_foundSongs[index].artist.toString()} album',
                            style: const TextStyle(color: Colors.black),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const Divider(
                          height: 0,
                          indent: 85,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  )
                : const Center(
                    child: Text(
                      'Nothing found',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),
          ),
        ],
      ),
    ));
  }
}
