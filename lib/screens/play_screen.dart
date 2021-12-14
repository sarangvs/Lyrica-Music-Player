import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../Database/database_handler.dart';
import '../Database/db.dart';
import 'package:rxdart/rxdart.dart';
import '../Widgets/notification_controll.dart';



class PlayScreen extends StatefulWidget {
  SongModel songInfo;

  PlayScreen(
      {required this.songInfo, required this.changeTrack, required this.key})
      : super(key: key);

  Function changeTrack;
  @override
  final GlobalKey<PlayScreenState> key;

  @override
  PlayScreenState createState() => PlayScreenState();
}

class PlayScreenState extends State<PlayScreen> {
  double minimumValue = 0.0, maximumValue = 0.0, currentValue = 0.0;
  String currentTime = '', endTime = '';
  bool isPlaying = false;

  DatabaseHandler? handler;
  dynamic songTitle_2;
  dynamic songId_2;
  dynamic songData_2;

  //late final PageManger _pageManager;

  final AudioPlayer player = AudioPlayer();
  List<String> listName = [];

  @override
  void initState() {
    super.initState();
    // _pageManager = PageManger();
    addUser(songTitle_2, songId_2, songData_2);
    handler = DatabaseHandler();
    setSong(widget.songInfo);
    // songFav();
    player.play();
  }

  @override
  void dispose() {
    super.dispose();
    player.dispose();
  }

  Future<void> songFav() async {
    // handler =DatabaseHandler();
    listName = await handler!.retrieveFavUsers();
    for (int i = 0; i < listName.length; i++) {
      if (listName[i] == widget.songInfo.title) {
        setState(() {
          fav = 1;
        });
      } else {
        setState(() {
          fav = 0;
        });
      }
    }
  }

  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          player.positionStream,
          player.bufferedPositionStream,
          player.durationStream,
          (position, bufferedPosition, duration) =>
              PositionData(position, duration ?? Duration.zero));

  ///ADDING SONGS
  Future<int> addUser(songTitle_2, songId_2, songData_2) async {
    final User firstUser =
        User(name: songTitle_2, num: songId_2, location: songData_2);
    final List<User> listOfUsers = [firstUser];
    return await handler!.insertUser(listOfUsers);
  }

  void setSong(SongModel songInfo) async {
    widget.songInfo = songInfo;
    await player.setUrl(widget.songInfo.data);
    currentValue = minimumValue;
    maximumValue = player.duration!.inMilliseconds.toDouble();
    if (currentValue == maximumValue) {
      widget.changeTrack(true);
      songFav();
    }
    setState(() {
      currentTime = getDuration(currentValue);
      endTime = getDuration(maximumValue);
    });
    isPlaying = false;
    changeStatus();
    player.positionStream.listen((duration) {
      currentValue = duration.inMilliseconds.toDouble();
      setState(() {
        currentTime = getDuration(currentValue);
        if (currentValue == maximumValue) {
          widget.changeTrack(true);
          songFav();
        }
      });
    });
  }

  void stopSong() {
    setState(() {
      player.pause();
    });
  }

  void changeStatus() {
    setState(() {
      isPlaying = !isPlaying;
    });
    setState(() {
      if (isPlaying) {
        player.play();
      } else {
        player.pause();
      }
    });
  }

  void nextSong() {
    setState(() {
      widget.changeTrack(true);
    });
  }

  String getDuration(double value) {
    final Duration duration = Duration(milliseconds: value.round());

    return [duration.inMinutes, duration.inSeconds]
        .map((element) => element.remainder(60).toString().padLeft(2, '0'))
        .join(':');
  }

  int fav = 0;
  int shuffle = 0;
  int repeat = 0;
  int play = 0;

//  bool isPlaying=false;
  bool isPaused = false;

  @override
  Widget build(BuildContext context) {
    // var bookmarkBloc = Provider.of<BookMarkBloc>(context);

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.grey[50],
            body: Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: screenHeight - 250,
                  child: StreamBuilder<SequenceState?>(
                    stream: player.sequenceStateStream,
                    builder: (context, snapshot) {
                      return QueryArtworkWidget(
                        id: widget.songInfo.id,
                        type: ArtworkType.AUDIO,
                        artworkFit: BoxFit.cover,
                        artworkBorder: BorderRadius.zero,
                        nullArtworkWidget: Container(
                          decoration: const BoxDecoration(
                              borderRadius: BorderRadius.zero,
                              color: Colors.black),
                          child: const Image(
                            image: AssetImage('images/musicimage.png'),
                            fit: BoxFit.cover,
                          ),
                          // height: 150,
                          // width: 100,
                        ),
                      );
                    },
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: AppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    leading: IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        stopSong();
                        debugPrint('Back button clicked');
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: screenHeight / 2.3,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.zero, topRight: Radius.circular(60)),
                      color: Colors.white,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: fav == 0
                                  ? const Icon(Icons.favorite_border)
                                  : const Icon(
                                      Icons.favorite,
                                      color: Colors.orange,
                                    ),
                              onPressed: () {
                                setState(() {
                                  songTitle_2 = widget.songInfo.title;
                                  songData_2 = widget.songInfo.data;
                                  songId_2 = widget.songInfo.id;
                                  addUser(songTitle_2, songId_2, songData_2);
                                  fav == 0 ? fav = 1 : fav = 0;
                                });
                              },
                            ),

                            // SizedBox(
                            //   width: Width / 5,
                            // ),
                            StreamBuilder<bool>(
                              stream: player.shuffleModeEnabledStream,
                              builder: (context, snapshot) {
                                final shuffleModeEnabled =
                                    snapshot.data ?? false;
                                return IconButton(
                                  icon: shuffleModeEnabled
                                      ? const Icon(Icons.shuffle,
                                          color: Colors.orange)
                                      : const Icon(Icons.shuffle,
                                          color: Colors.black),
                                  onPressed: () async {
                                    final enable = !shuffleModeEnabled;
                                    if (enable) {
                                      await player.shuffle();
                                    }
                                    await player.setShuffleModeEnabled(enable);
                                  },
                                );
                              },
                            ),
                            // SizedBox(
                            //   width: Width / 5,
                            // ),
                            StreamBuilder<LoopMode>(
                              stream: player.loopModeStream,
                              builder: (context, snapshot) {
                                final loopMode = snapshot.data ?? LoopMode.off;
                                const icons = [
                                  Icon(Icons.repeat, color: Colors.black),
                                  Icon(Icons.repeat, color: Colors.orange),
                                  Icon(Icons.repeat_one, color: Colors.orange),
                                ];
                                const cycleModes = [
                                  LoopMode.off,
                                  LoopMode.all,
                                  LoopMode.one,
                                ];
                                final index = cycleModes.indexOf(loopMode);
                                return IconButton(
                                  icon: icons[index],
                                  onPressed: () {
                                    player.setLoopMode(cycleModes[
                                        (cycleModes.indexOf(loopMode) + 1) %
                                            cycleModes.length]);
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 50,
                          width: screenWidth,
                          child: StreamBuilder<SequenceState?>(
                            stream: player.sequenceStateStream,
                            builder: (context, snapshot) {
                              return Marquee(
                                text: widget.songInfo.title,
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'roboto',
                                    color: Colors.black87
                                ),
                                blankSpace: 150,
                                velocity: 50,
                              );
                            },
                          ),
                        ),
                        StreamBuilder<SequenceState?>(
                          stream: player.sequenceStateStream,
                          builder: (context, snapshot) {
                            return Text(
                              widget.songInfo.artist.toString(),
                              style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'roboto',
                                  color: Colors.black87),
                            );
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: screenWidth - 15,
                          height: 50,
                          child: StreamBuilder<PositionData>(
                            stream: _positionDataStream,
                            builder: (context, snapshot) {
                              final positionData = snapshot.data;
                              return SeekBar(
                                duration:
                                    positionData?.duration ?? Duration.zero,
                                position:
                                    positionData?.position ?? Duration.zero,
                                onChangeEnd: (newPosition) {
                                  player.seek(newPosition);
                                },
                              );
                            },
                          ),
                        ),
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  width: 50,
                                ),
                                StreamBuilder<SequenceState?>(
                                  stream: player.sequenceStateStream,
                                  builder: (context, snapshot) => IconButton(
                                      icon: const Icon(Icons.fast_rewind,
                                          size: 30, color: Colors.black),
                                      onPressed: () {
                                        widget.changeTrack(false);
                                        songFav();
                                      }),
                                ),
                                SizedBox(
                                  height: 90,
                                  width: 90,
                                  child: StreamBuilder<PlayerState>(
                                    stream: player.playerStateStream,
                                    builder: (context, snapshot) {
                                      final playerState = snapshot.data;
                                      final processingState =
                                          playerState?.processingState;
                                      final playing = playerState?.playing;
                                      if (playing != true) {
                                        return IconButton(
                                          icon: const Icon(
                                            Icons.play_circle_fill,
                                            color: Colors.orange,
                                            size: 70,
                                          ),
                                          onPressed: player.play,
                                        );
                                      } else if (processingState !=
                                          ProcessingState.completed) {
                                        return IconButton(
                                          icon: const Icon(
                                              Icons.pause_circle_filled,
                                              color: Colors.orange,
                                              size: 70),
                                          onPressed: player.pause,
                                        );
                                      } else {
                                        return StreamBuilder<PlayerState>(
                                            stream: player.playerStateStream,
                                            builder: (context, snapshot) {
                                              return widget.changeTrack(true);
                                            });
                                      }
                                    },
                                  ),
                                ),
                                StreamBuilder<SequenceState?>(
                                  stream: player.sequenceStateStream,
                                  builder: (context, snapshot) => IconButton(
                                      icon: const Icon(Icons.fast_forward,
                                          size: 30, color: Colors.black),
                                      onPressed: () {
                                        widget.changeTrack(true);
                                        songFav();
                                      }),
                                ),
                                const SizedBox(
                                  width: 50,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
        )
    );
  }
}

class PositionData {
  final Duration position;
  final Duration duration;

  PositionData(this.position, this.duration);
}
