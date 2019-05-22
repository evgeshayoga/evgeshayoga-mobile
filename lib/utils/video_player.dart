import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';

class ChewieDemo extends StatefulWidget {
  ChewieDemo({this.videoUrl});

  final String videoUrl;

  @override
  State<StatefulWidget> createState() {
    var ctrl = VideoPlayerController.network(videoUrl);
    return _ChewieDemoState(ctrl);
  }
}

class _ChewieDemoState extends State<ChewieDemo> {
  _ChewieDemoState(this._videoPlayerController);
//  TargetPlatform _platform;
  VideoPlayerController _videoPlayerController;
//  ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    _videoPlayerController.addListener(listener);
  }
  @override
  void dispose() {
    _videoPlayerController.dispose();
//    _chewieController.dispose();
    super.dispose();
  }
  void listener() async {
    var pos = await _videoPlayerController.position;

    if (pos >= _videoPlayerController.value.duration) {
      print(">>>>> now rewind");
      _videoPlayerController.seekTo(new Duration());
      _videoPlayerController.pause();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Flexible(
              child: Chewie(
                  controller: ChewieController(
                    autoInitialize: true,
                    videoPlayerController: _videoPlayerController,
                    aspectRatio: 3 / 2,
                    autoPlay: false,
                    looping: false,
                  )
              ),
          ),
        ],
      ),
    );
  }

}
