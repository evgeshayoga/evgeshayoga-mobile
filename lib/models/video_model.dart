import 'package:firebase_database/firebase_database.dart';

class Video {
  String content;
  String videoUrl;
  String iframe;
  String picture;
  String subtitle;
  String title;


  Video({this.content, this.videoUrl, this.iframe, this.picture, this.subtitle,
    this.title});

//  Video.fromSnapshot(DataSnapshot snapshot)
//      :
//        content = snapshot.value["content"],
//        videoUrl = snapshot.value["hls"],
//        iframe = snapshot.value["iframe"],
//        picture = snapshot.value["picture"],
//        subtitle = snapshot.value["subtitle"],
//        title = snapshot.value["title"];
}