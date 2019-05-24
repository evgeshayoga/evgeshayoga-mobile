import 'package:evgeshayoga/old_files/video.dart';
import 'package:evgeshayoga/old_files/video_card.dart';
import 'package:evgeshayoga/utils/video_player.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class PowerYoga extends StatefulWidget {
  @override
  _PowerYogaState createState() => _PowerYogaState();
}

class _PowerYogaState extends State<PowerYoga> {
  List _videosPoweryogaWeek1 = [
    {
      "name": "butterfly",
      "url":
          "https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4"
    },
    {
      "name": "bunny",
      "url":
          "http://www.sample-videos.com/video123/mp4/720/big_buck_bunny_720p_20mb.mp4"
    }
  ];
  @override
  Widget build(BuildContext context) {
    List <Widget> videos = [];
    _videosPoweryogaWeek1.forEach((item) {
      videos.add(Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0)));
      videos.add(Text(item["name"]));
      videos.add(ChewieDemo(videoUrl: item["url"]));
    });


    return Scaffold(
      appBar: AppBar(
        title: Text("PowerYoga"),
        centerTitle: true,
        backgroundColor: Colors.green.shade400,
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: <Widget>[
            Text(
              "Добро пожаловать в ряды участников PowerYoga марафона!",
              style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 25,
                  color: Colors.black54),
            ),
            Text(
              "Прежде, чем преступить к практикам, ознакомьтесь с приветственным видео от преподавателей курса и убедитесь, что у вас есть все необходимое для занятий",
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 15,
                  fontStyle: FontStyle.normal,
                  color: Colors.blueGrey),
            ),
//            Flexible(
//              child: Column(mainAxisSize: MainAxisSize.min, children: List.from(videoBlocks)),
//            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: videos,
            ),
          ],
        ),
      ),
    );
  }
}
