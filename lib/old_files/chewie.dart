import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';

class ChewieVideo extends StatefulWidget {
  ChewieVideo({Key key, this.controller}) : super(key: key);
  final VideoPlayerController controller;


  @override
  _ChewieVideoState createState() => _ChewieVideoState();

}

class _ChewieVideoState extends State<ChewieVideo> {
VideoPlayerController videoPlayerController;


void initState() {
  super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Flexible(
            child: Stack(
              children: <Widget>[
                GestureDetector(
                  child: Chewie(
                      controller: ChewieController(
                        autoInitialize: true,
                        videoPlayerController: videoPlayerController,
                        aspectRatio: 3 / 2,
                        autoPlay: true,
                        looping: true,
                      )),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
