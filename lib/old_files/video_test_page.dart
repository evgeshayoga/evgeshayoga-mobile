import 'package:evgeshayoga/ui/programs/components/chewie_player.dart';
import 'package:evgeshayoga/old_files/video_card.dart';
import 'package:evgeshayoga/old_files/video.dart';
import 'package:flutter/material.dart';

class VideoTestPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return BackButton(
              color: Colors.blueGrey,
            );
          },
        ),
        centerTitle: true,
        title: Text("Video",),
      ),
      body: Column(
        children: <Widget>[
//           VideoDemo()
        ChewieVideo('https://player.vimeo.com/external/304663654.m3u8?s=644f00d404db6568b85e71448870e5f28e9707e0'),
//          Video(videoUrl: 'https://player.vimeo.com/external/304663654.m3u8?s=644f00d404db6568b85e71448870e5f28e9707e0',),
        ],
      )
    );
  }
}
