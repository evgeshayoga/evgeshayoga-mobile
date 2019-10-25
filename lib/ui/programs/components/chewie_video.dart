import 'package:chewie/chewie.dart';
import 'package:chewie/src/chewie_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ChewieVideo extends StatefulWidget {
  String videoUrl='';
  String videoThumbnail='';
//  String thumbnailUrl = "https://evgeshayoga.com/images/userfiles/images/t/w1-2-pra.png";

  ChewieVideo(this.videoUrl, this.videoThumbnail); //  final String title;

  @override
  State<StatefulWidget> createState() {
    return _ChewieVideoState();
  }
}

class _ChewieVideoState extends State<ChewieVideo> {
  TargetPlatform _platform;
  VideoPlayerController _videoPlayerController;
  ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.network(widget.videoUrl);
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      aspectRatio: 3 / 2,
      autoInitialize: widget.videoThumbnail == null || widget.videoThumbnail == '' ? true : false,
      autoPlay: false,
      looping: false,
      placeholder: Container(
//        color: Colors.blueGrey,
        child: Image.network(widget.videoThumbnail),
      )
      // Try playing around with some of these other options:

      // showControls: false,
      // materialProgressColors: ChewieProgressColors(
      //   playedColor: Colors.red,
      //   handleColor: Colors.blue,
      //   backgroundColor: Colors.grey,
      //   bufferedColor: Colors.lightGreen,
      // ),
      // placeholder: Container(
      //   color: Colors.grey,
      // ),
      // autoInitialize: true,
    );
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Chewie(
      controller: _chewieController,
    );
  }
}
