import 'package:evgeshayoga/models/video.dart';
import 'package:evgeshayoga/models/yoga_online_lesson.dart';
import 'package:evgeshayoga/ui/video_content/components/video_blocks_column.dart';
import 'package:evgeshayoga/utils/ProgressHUD.dart';
import 'package:evgeshayoga/utils/style.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class LessonBuilder extends StatefulWidget {
  final int id;

  LessonBuilder(this.id, {Key? key}) : super(key: key);

  @override
  _LessonBuilderState createState() => _LessonBuilderState();
}

class _LessonBuilderState extends State<LessonBuilder> {
  final FirebaseDatabase database = FirebaseDatabase.instance;
  YogaOnlineLesson? yogaOnlineLesson;
  List<VideoModel> videos = [];
  bool isInAsyncCall = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      isInAsyncCall = true;
    });
    database
        .ref("videos")
        .child('${widget.id}')
        .once()
        .then((event) {
      if (this.mounted) {
        setState(() {
          yogaOnlineLesson = YogaOnlineLesson.fromFB(new Map<String, dynamic>.from(event.snapshot.value as dynamic));
          videos = yogaOnlineLesson!.getVideos();
          isInAsyncCall = false;
        });
      }
    });
  }

  Widget upperContent() {
    return DefaultTextStyle(
      child: HtmlWidget(
        yogaOnlineLesson!.content,
      ),
      style: Style.regularTextStyle,
      textAlign: TextAlign.justify,
    );
  }

  Widget build(BuildContext context) {
    if (yogaOnlineLesson == null) {
      return Container(height: 300, child: progressHUD(isInAsyncCall));
    }

    return VideoBlocks(videos, upperContent: upperContent());
  }
}
