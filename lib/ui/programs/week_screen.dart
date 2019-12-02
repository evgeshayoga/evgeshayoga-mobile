import 'package:evgeshayoga/models/week.dart';
import 'package:evgeshayoga/ui/programs/components/video_blocks_column.dart';
import 'package:evgeshayoga/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class WeekScreen extends StatelessWidget {
  final Week week;

  WeekScreen(this.week);

  @override
  Widget build(BuildContext context) {
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
      body: ListView(
        padding: EdgeInsets.all(8),
        children: <Widget>[
          DefaultTextStyle(
            child: HtmlWidget(
              week.content,
              webView: true,
            ),
            style: Style.regularTextStyle,
            textAlign: TextAlign.justify,
          ),
          VideoBlocks(week.getVideos()),
        ],
      ),
    );
  }
}
