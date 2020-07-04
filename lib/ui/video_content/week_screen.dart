import 'package:evgeshayoga/models/video.dart';
import 'package:evgeshayoga/models/week.dart';
import 'package:evgeshayoga/ui/video_content/components/video_blocks_column.dart';
import 'package:evgeshayoga/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class WeekScreen extends StatelessWidget {
  final Week week;

  WeekScreen(this.week);

  @override
  Widget build(BuildContext context) {
    List<VideoModel> videos = week.getVideos();
    Widget upperContent = Padding(
      padding: EdgeInsets.all(8),
      child: DefaultTextStyle(
        child: HtmlWidget(
          week.content,
          webView: true,
        ),
        style: Style.regularTextStyle,
        textAlign: TextAlign.justify,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return BackButton(
              color: Style.blueGrey,
            );
          },
        ),
        centerTitle: true,
        backgroundColor: Style.pinkMain,
        title: Text(
          week.title,
          style: Style.titleTextStyle,
        ),
      ),
      body: VideoBlocks(videos, upperContent: upperContent),
    );
  }
}
