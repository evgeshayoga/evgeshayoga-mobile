import 'package:evgeshayoga/ui/video_test_page.dart';
import 'package:flutter/services.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart' as prefix0;
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';

class Video extends StatefulWidget {
  bool rotated = false;
  String videoUrl = '';

  Video({this.rotated = false, this.videoUrl});

  @override
  _VideoState createState() => _VideoState();
}

class _VideoState extends State<Video> {
  VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _controller.value.isPlaying ? _controller.pause() : _controller.play();
        });
      },
      child: Stack(
        children: <Widget>[
          _controller.value.initialized
              ? AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          )
              : Container(),
          Positioned(
            bottom: 0,
            child: Row(
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
                      var router =
                      new MaterialPageRoute(builder: (BuildContext context) {
//                        SystemChrome.setEnabledSystemUIOverlays([]);
                        return FullScreenVideo(videoUrl: widget.videoUrl,);
                      });
                      widget.rotated
                          ? Navigator.pop(context)
                          : Navigator.of(context).push(router);
                    },
//                onPressed: () {
//                  setState(() {
//                    rotated = !rotated;
//                  });
//                },
                    child: Icon(
                      widget.rotated ? Icons.arrow_back : Icons.aspect_ratio,
                    ))
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}

class FullScreenVideo extends StatefulWidget {
  String videoUrl = '';

  FullScreenVideo({this.videoUrl});

  @override
  _FullScreenVideoState createState() => _FullScreenVideoState();
}

class _FullScreenVideoState extends State<FullScreenVideo> {

  @override
  void setState(fn) {
    super.setState(fn);
    SystemChrome.setEnabledSystemUIOverlays([]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: RotatedBox(
            quarterTurns: 1,
            child: Video(rotated: true, videoUrl: widget.videoUrl,),
          ),
        ));
  }
}
