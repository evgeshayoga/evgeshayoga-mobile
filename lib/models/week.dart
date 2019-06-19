import 'package:firebase_database/firebase_database.dart';

class Week {
  String content;
  String thumbnailUrl;
  String title;

  Week({this.content, this.thumbnailUrl, this.title});

  Week.fromObject(dynamic value)
      : content = value["content"],
        thumbnailUrl = value["thumbnailUrl"],
        title = value["title"];
}
