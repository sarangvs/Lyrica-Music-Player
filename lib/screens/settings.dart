import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musicplayer/controller/music_controller.dart';
import 'package:share_plus/share_plus.dart';

class Settingspage extends StatelessWidget {
   Settingspage({Key? key}) : super(key: key);

  ///GETX CONTROLLER
  MusicController musicController = Get.put(MusicController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: const Text(
              'Settings',
              style:
              TextStyle(color: Colors.black, fontWeight: FontWeight.normal),
            ),
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            titleSpacing: -5,
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ListTile(
                  title: const Text('Privacy and Security'),
                  leading: const Icon(
                    Icons.lock,
                    color: Colors.black,
                  ),
                  minLeadingWidth: 10,
                  onTap: () {
                    musicController.launchURLBrowser();
                  },
                ),
                ListTile(
                  title: const Text('Share App'),
                  leading: const Icon(
                    Icons.share,
                    color: Colors.black,
                  ),
                  minLeadingWidth: 10,
                  onTap: () {
                    Share.share(
                        'https://play.google.com/store/apps/details?id=com.sarangvs.musicplayer',
                        subject: 'Try out Lyrica music player!');
                  },
                ),
                ListTile(
                  title: const Text('Rate App'),
                  leading: const Icon(
                    Icons.star,
                    color: Colors.black,
                  ),
                  minLeadingWidth: 10,
                  onTap: () {
                    musicController.rateApp();
                  },
                ),
                ListTile(
                  title: const Text('Help and Support'),
                  leading: const Icon(
                    Icons.headset_mic,
                    color: Colors.black,
                  ),
                  minLeadingWidth: 10,
                  onTap: () {
                    Get.defaultDialog(
                        title: 'Contact', middleText: 'sarang6180@gmail.com');
                  },
                ),
                ListTile(
                  title: const Text('About'),
                  leading: const Icon(
                    Icons.info,
                    color: Colors.black,
                  ),
                  minLeadingWidth: 10,
                  onTap: () {
                    showAboutDialog(
                      context: context,
                      applicationName: 'Lyrica',
                      applicationVersion: '1.0.1',
                      applicationLegalese:
                      'Copyright © Lyrica ${DateTime.now().year.toString()}',
                    );
                  },
                ),
              ],
            ),
          )),
    );
  }
}

