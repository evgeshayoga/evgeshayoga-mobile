import 'package:evgeshayoga/models/video.dart';
import 'package:evgeshayoga/utils/style.dart';
import 'package:flutter/material.dart';

import 'chewie_video.dart';

class VideoBlocks extends StatelessWidget {
  final List<VideoModel> videos;
  final Widget? upperContent;

  VideoBlocks(this.videos, {this.upperContent});

  @override
  Widget build(BuildContext context) {
    List<Widget> videoBlocks = upperContent != null
        ? [
            Container(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: upperContent!,
              ),
            )
          ]
        : [];
    videos.forEach((VideoModel video) {
      videoBlocks.add(
        Container(
          // margin: EdgeInsets.all(8),
          margin: EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            contentPadding: EdgeInsets.all(0),
            title: Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                video.title + ". " + video.subtitle,
                style: Style.headerTextStyle,
              ),
            ),
            subtitle: Column(
              children: <Widget>[
                video.hls.isNotEmpty
                    ? ChewieVideo(video.hls, video.thumbnail)
                    : Text(""),
                Padding(
                  padding: EdgeInsets.all(16),
                  child: video.content.isEmpty
                      ? Text("")
                      : Text(
                          video.content,
                          style: Style.regularTextStyle,
                        ),
                ),
              ],
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
