import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:musicplayer/screens/favourites.dart';
import 'package:musicplayer/screens/my_playlist.dart';
import 'package:musicplayer/screens/searchbar.dart';
import 'package:musicplayer/screens/settings.dart';
import 'screens/song_screen.dart';
import 'screens/play_screen.dart';
import 'package:just_audio_background/just_audio_background.dart';



void main() async {
 // await setupServiceLocator();

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Music Player',
      home: Appbar(),
    );
  }
}

class Appbar extends StatefulWidget {
  const Appbar({Key? key}) : super(key: key);

  @override
  _AppbarState createState() => _AppbarState();
}

var obj =  Songscreen();

class _AppbarState extends State<Appbar> {
  final GlobalKey<PlayScreenState> key = GlobalKey<PlayScreenState>();

  int playbutton = 0;
  var pages = [
    Songscreen(),
     Myplaylist(),
     Favourites(),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: SafeArea(
            child: Scaffold(
          backgroundColor: Colors.grey[50],
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title:const Text(
                    'Lyrica',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        fontFamily: 'Exo2'),
                  ),

            actions: [
              IconButton(
                padding: const EdgeInsets.only(
                    left: 35, right: 0, top: 0, bottom: 0),
                icon: const Icon(
                  Icons.search,
                  color: Colors.black,
                ),
                onPressed: () {
                  setState(() {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SearchBar(),
                        ));
                  });
                  debugPrint('search button pressed');
                },
              ),
              IconButton(
                padding: EdgeInsets.zero,
                icon: const Icon(
                  Icons.settings,
                  color: Colors.black87,
                ),
                onPressed: () {
                  debugPrint('Settings button print');
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>  Settingspage()));
                },
              ),
            ],
            bottom: const TabBar(
              indicatorColor: Colors.black54,
              indicatorSize: TabBarIndicatorSize.tab,
              labelColor: Colors.black87,
              labelStyle: TextStyle(
                  fontSize: 14,
                  fontFamily: 'Exo2',
                  fontWeight: FontWeight.w500),
              unselectedLabelStyle: TextStyle(fontSize: 12),
              tabs: [
                Tab(
                  text: 'SONGS',
                ),
                Tab(
                  text: 'PLAYLIST',
                ),
                Tab(
                  text: 'FAVOURITES',
                ),
              ],
            ),
          ),
          body: Stack(
            children: [
              TabBarView(
                children: pages,
              ),
              // Positioned(
              //     bottom: 0,
              //     left: 0,
              //     right: 0,
              //     height: Height / 7,
              //     child: GestureDetector(
              //       onTap: () {
              //         Navigator.push(
              //           context,
              //     MaterialPageRoute(builder: (context) =>
              //     PlayScreen(songInfo:null ,changeTrack: null, Key: null,)),
              //         );
              //       },
              //       child: Container(
              //         child: Column(
              //           children: [
              //             Row(
              //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //               children: [
              //                 const SizedBox(width: 4,),
              //                 SizedBox(
              //                   width: Width * 7 / 10,
              //                   child: Center(
              //                     child: RichText(
              //                       text: const TextSpan(
              //                    text: "The Kid LAROI, Justin Bieber - STAY",
              //                         style: TextStyle(
              //                             fontSize: 16,
              //                             fontWeight: FontWeight.bold,
              //                             fontFamily: 'roboto',
              //                             color: Colors.black87),
              //                         children: [],
              //                       ),
              //                   overflow: TextOverflow.ellipsis,maxLines: 1,
              //                     ),
              //                   ),
              //                 ),
              //
              //                 Expanded(
              //                       child: SizedBox(
              //                         height: Height / 7,
              //                         width: Width / 8,
              //                   child: ValueListenableBuilder<ButtonState>(
              //                 valueListenable: _pageManager.buttonNotifier,
              //                             builder: (_,value,__){
              //                               switch(value){
              //                                 case ButtonState.paused:
              //                                   return IconButton(
              //                      icon: const Icon(Icons.play_circle_fill),
              //                                     iconSize: 70,
              //                                     color: Colors.redAccent,
              //                                     onPressed: (){
              //                                       _pageManager.play();
              //                                     },
              //                                   );
              //                                 case ButtonState.playing:
              //                                   return IconButton(
              //                   icon: const Icon(Icons.pause_circle_filled),
              //                                     iconSize: 70,
              //                                     color: Colors.redAccent,
              //                                     onPressed: (){
              //                                       _pageManager.pause();
              //                                     },
              //                                   );
              //                               }
              //                             }
              //                         )
              //                       ),
              //                       ),
              //
              //               ],
              //             ),
              //           ],
              //         ),
              //         decoration: const BoxDecoration(
              //           borderRadius:
              //               BorderRadius.only(topRight: Radius.circular(60)),
              //           color: Colors.white,
              //         ),
              //       ),
              //     ))
            ],
          ),
        )));
  }
}
