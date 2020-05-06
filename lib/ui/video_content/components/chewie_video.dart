import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:evgeshayoga/utils/style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:video_player/video_player.dart';

class ChewieVideo extends StatefulWidget {
  String videoUrl = '';
  String videoThumbnail = '';

  ChewieVideo(this.videoUrl, this.videoThumbnail); //  final String title;

  @override
  State<StatefulWidget> createState() {
    return _ChewieVideoState();
  }
}

class _ChewieVideoState extends State<ChewieVideo> {
  VideoPlayerController _videoPlayerController;
  ChewieController _chewieController;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.network(widget.videoUrl);
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      aspectRatio: 16 / 9,
      autoInitialize: !hasThumbnail,
      autoPlay: false,
      looping: false,
      allowedScreenSleep: false,
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

  get hasThumbnail =>
      widget.videoThumbnail != null && widget.videoThumbnail.length > 0;

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Chewie chewie = Chewie(controller: _chewieController);
    if (!hasThumbnail) {
      return chewie;
    }

    Widget child = Container(
      child: chewie,
      height: 230,
      alignment: Alignment.center,
    );
    if (!_initialized) {
      child = Container(
        height: 230,
        child: Stack(
          children: <Widget>[
            Container(alignment: Alignment.center, child: chewie),
            Container(
              color: Colors.white,
            ),
            Container(
                alignment: Alignment.center,
                child: widget.videoThumbnail.isNotEmpty
                    ? FadeInImage(placeholder: MemoryImage(kTransparentImage), image: CachedNetworkImageProvider(widget.videoThumbnail))
                    : null,
            ),
            Container(
              alignment: Alignment.center,
              child: Stack(
                children: <Widget>[
                  Container(
                      alignment: Alignment.center,
                      height: 56,
                      width: 56,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        shape: BoxShape.circle,
                      ),
                  ),
                  Icon(
                    Icons.play_circle_filled,
                    color: Style.pinkMain,
                    size: 56.0,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        if (!_initialized) {
          _videoPlayerController.initialize();
          setState(() {
            _initialized = true;
          });
        }
      },
      child: child,
    );
  }
}
