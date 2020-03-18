import 'package:evgeshayoga/models/video_model.dart';
import 'package:evgeshayoga/utils/style.dart';
import 'package:flutter/material.dart';

import 'chewie_video.dart';

class VideoBlocks extends StatelessWidget {
  List<VideoModel> videos;
  Widget upperContext;

  VideoBlocks(this.videos, {this.upperContext});

  @override
  Widget build(BuildContext context) {
    List<Widget> videoBlocks = upperContext != null ? [upperContext] : [];
    videos.forEach((video) {
      videoBlocks.add(
        Card(
          margin: EdgeInsets.fromLTRB(0, 8, 0, 8),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(
                video.title + ". " + video.subtitle,
                style: Style.headerTextStyle,
              ),
              subtitle: Column(
                children: <Widget>[
                  ChewieVideo(video.hls, video.thumbnail),
                  video.content == null
                      ? null
                      : Text(
                          video.content,
                          style: Style.regularTextStyle,
                        ),
//              Padding(padding: const EdgeInsets.only(bottom: 8.0))
//              Divider(
//                color: Style.blueGrey,
//              )
                ],
              ),
            ),
          ),
        ),
      );
    });
    if (upperContext != null) {
      return ListView.builder(
        itemCount: videoBlocks.length,
        itemBuilder: (context, i) => videoBlocks[i],
        shrinkWrap: true,
      );
    }
    return Column(children: videoBlocks);
  }
}
