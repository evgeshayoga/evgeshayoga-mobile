import 'package:evgeshayoga/models/video_model.dart';
import 'package:evgeshayoga/models/yoga_online_lesson.dart';
import 'package:evgeshayoga/ui/programs/components/video_blocks_column.dart';
import 'package:evgeshayoga/utils/ProgressHUD.dart';
import 'package:evgeshayoga/utils/style.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class LessonBuilder extends StatefulWidget {
  final int id;

  LessonBuilder(this.id, {Key key}) : super(key: key);

  @override
  _LessonBuilderState createState() => _LessonBuilderState();
}

class _LessonBuilderState extends State<LessonBuilder> {
  final FirebaseDatabase database = FirebaseDatabase.instance;
  YogaOnlineLesson yogaOnlineLesson;
  List<VideoModel> videos = [];

  @override
  void initState() {
    super.initState();
    database
        .reference()
        .child("videos")
        .child('${widget.id}')
        .once()
        .then((snapshot) {
      setState(() {
        yogaOnlineLesson = YogaOnlineLesson.fromSnapshot(snapshot);
        videos = yogaOnlineLesson.getVideos();
        debugPrint("VIDEOS "+videos.length.toString());
      });
    });
  }

  Widget build(BuildContext context) {
    if (yogaOnlineLesson == null) {
      return Container(
        height: 300,
        child: progressHUD()
      );
    }


    return Column(
      children: <Widget>[
        Column(
          children: <Widget>[
            DefaultTextStyle(
              child: HtmlWidget(
                yogaOnlineLesson.content,
                webView: true,
              ),
              style: Style.regularTextStyle,
              textAlign: TextAlign.justify,
            )
          ],
        ),
        VideoBlocks(videos),
      ],
    );
  }
}
