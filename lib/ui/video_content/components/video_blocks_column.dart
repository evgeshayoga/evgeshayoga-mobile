import 'package:evgeshayoga/models/video.dart';
import 'package:evgeshayoga/utils/style.dart';
import 'package:flutter/material.dart';

import 'chewie_video.dart';

class VideoBlocks extends StatelessWidget {
  List<VideoModel> videos;
  Widget upperContent;

  VideoBlocks(this.videos, {this.upperContent});

  @override
  Widget build(BuildContext context) {
    List<Widget> videoBlocks = upperContent != null ? [upperContent] : [];
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
                  video.hls.isNotEmpty ? ChewieVideo(video.hls, video.thumbnail) : Text(""),
                  video.content == null
                      ? Text("")
                      : Text(
                          video.content,
                          style: Style.regularTextStyle,
                        ),
                ],
              ),
            ),
          ),
        ),
      );
    });
    if (upperContent != null) {
      return ListView.builder(
        itemCount: videoBlocks.length,
        itemBuilder: (context, i) => videoBlocks[i],
        shrinkWrap: true,
      );
    }
    return Column(children: videoBlocks);
  }
}
