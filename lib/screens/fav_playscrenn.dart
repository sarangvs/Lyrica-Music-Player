import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:rxdart/rxdart.dart';
import '../Widgets/notification_controll.dart';

class FavPlayScreen extends StatefulWidget {
  SongModel songData;


  FavPlayScreen(
      {required this.songData, required this.changeTrack, required this.key})
      : super(key: key);

  Function changeTrack;
  @override
  final GlobalKey<FavPlayScreenState> key;

  @override
  FavPlayScreenState createState() => FavPlayScreenState();
}

class FavPlayScreenState extends State<FavPlayScreen> {
  double minimumValue = 0.0, maximumValue = 0.0, currentValue = 0.0;
  String currentTime = '', endTime = '';
  bool isPlaying = false;

  // late final PageManger _pageManager;

  final AudioPlayer player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    // _pageManager = PageManger();
    setSong(widget.songData);
    player.play();
  }

  @override
  void dispose() {
    super.dispose();
    player.dispose();
  }

  double valueReturn(double min, double max, double current) {
    if (current >= min && current <= max) {
      return current;
    } else {
      setState(() {
        widget.changeTrack(true);
      });
      return max;
    }
  }

  void setSong(SongModel songData) async {
    widget.songData = songData;
    await player.setUrl(widget.songData.data);
    currentValue = minimumValue;
    maximumValue = player.duration!.inMilliseconds.toDouble();
    if (currentValue == maximumValue) {
      widget.changeTrack(true);
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
        }
      });
    });
  }

  void changeStatus() {
    setState(() {
      isPlaying = !isPlaying;
      if (isPlaying) {
        player.play();
      } else {
        player.pause();
      }
    });
  }

  void nextSong() {
    setState(() {
      if (currentValue >= maximumValue) {
        widget.changeTrack(true);
      }
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

  bool isPaused = false;

  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          player.positionStream,
          player.bufferedPositionStream,
          player.durationStream,
          (position, bufferedPosition, duration) =>
              PositionData(position, duration ?? Duration.zero));

  @override
  Widget build(BuildContext context) {
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
                  height: screenHeight - 168,
                  child: StreamBuilder<SequenceState?>(
                    stream: player.sequenceStateStream,
                    builder: (context, snapshot) {
                      return QueryArtworkWidget(
                        id: widget.songData.id,
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
                        player.pause();
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
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                        //   crossAxisAlignment: CrossAxisAlignment.center,
                        //   children: [
                        //     IconButton(
                        //       icon: fav == 0
                        //           ? const Icon(Icons.favorite_border)
                        //           : const Icon(
                        //         Icons.favorite,
                        //         color: Colors.orange,
                        //       ),
                        //       onPressed: () {
                        //         debugPrint("fav button");
                        //         setState(() {
                        //           fav == 0 ? fav = 1 : fav = 0;
                        //         });
                        //       },
                        //     ),
                        //     // SizedBox(
                        //     //   width: Width / 5,
                        //     // ),
                        //     IconButton(
                        //       icon: shuffle == 0
                        //           ? const Icon(Icons.shuffle)
                        //           : const Icon(
                        //         Icons.shuffle,
                        //         color: Colors.orange,
                        //       ),
                        //       onPressed: () {
                        //         debugPrint("Shuffle button");
                        //         setState(() {
                        //           shuffle == 0 ? shuffle = 1 : shuffle = 0;
                        //         });
                        //       },
                        //     ),
                        //     // SizedBox(
                        //     //   width: Width / 5,
                        //     // ),
                        //     IconButton(
                        //       icon: repeat == 0
                        //           ? const Icon(Icons.repeat)
                        //           : const Icon(
                        //         Icons.repeat,
                        //         color: Colors.orange,
                        //       ),
                        //       onPressed: () {
                        //         debugPrint("repeat button");
                        //         setState(() {
                        //           repeat == 0 ? repeat = 1 : repeat = 0;
                        //         });
                        //       },
                        //     ),
                        //   ],
                        // ),
                        SizedBox(
                          height: 50,
                          width: screenWidth,
                          child: StreamBuilder<SequenceState?>(
                            stream: player.sequenceStateStream,
                            builder: (context, snapshot) {
                              return Marquee(
                                text: widget.songData.title,
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'roboto',
                                    color: Colors.black87),
                                blankSpace: 150,
                                velocity: 50,
                              );
                            },
                          ),
                        ),
                        const Text('<unknown>'),
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
                                      }),
                                ),
                                SizedBox(
                                  height: 90,
                                  width: 90,
                                  child: StreamBuilder<PlayerState>(
                                    stream: player.playerStateStream,
                                    builder: (context, snapshot) {
                                      final playerState = snapshot.data;
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
                                      } else {
                                        return IconButton(
                                          icon: const Icon(
                                              Icons.pause_circle_filled,
                                              color: Colors.orange,
                                              size: 70),
                                          onPressed: player.pause,
                                        );
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
            )));
  }
}

class PositionData {
  final Duration position;
  final Duration duration;

  PositionData(this.position, this.duration);
}
