import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';

class Video extends StatefulWidget {
  @override
  _VideoState createState() => _VideoState();
}


class _VideoState extends State<Video> {
  VideoPlayerController _controller;
  bool rotated = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
        'http://www.sample-videos.com/video123/mp4/720/big_buck_bunny_720p_20mb.mp4')
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
        child: Column(
      children: <Widget>[
        Container(
//              quarterTurns: rotated ? 1 : 0,
          child: Column(
            children: <Widget>[
              _controller.value.initialized
                  ? AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    )
                  : Container(),
              Row(
                children: <Widget>[
                  FlatButton(
                      onPressed: () {
                        setState(() {
                          _controller.value.isPlaying
                              ? _controller.pause()
                              : _controller.play();
                        });
                      },
                      child: Icon(
                        _controller.value.isPlaying
                            ? Icons.pause
                            : Icons.play_arrow,
                      )),
                  FlatButton(
                      onPressed: () {
                        var router = new MaterialPageRoute(
                            builder: (BuildContext context) {
                          return FullScreenVideo();
                        });
                        Navigator.of(context).push(router);
                      },
//                onPressed: () {
//                  setState(() {
//                    rotated = !rotated;
//                  });
//                },
                      child: Icon(
                        rotated ? Icons.arrow_back : Icons.aspect_ratio,
                      ))
                ],
              )
            ],
          ),
        ),
      ],
    ));
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}

class FullScreenVideo extends StatefulWidget {
  @override
  _FullScreenVideoState createState() => _FullScreenVideoState();
}

class _FullScreenVideoState extends State<FullScreenVideo> {
  bool rotated = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          RotatedBox(
            quarterTurns: 1,
            child: Video(),
          )
        ],
      ),
        );
  }
}
