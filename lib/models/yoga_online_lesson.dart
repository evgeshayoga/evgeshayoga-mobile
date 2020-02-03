import 'package:evgeshayoga/models/video_model.dart';
import 'package:firebase_database/firebase_database.dart';

class YogaOnlineLesson {
  String content;
  int id;
  bool isActive;
  String thumbnailUrl;
  String title;
  String subtitle;
  List videoBlocks;
  int duration;
  String levelName;
  int level;
  List teachers;
  int type;
  String typeName;

  YogaOnlineLesson(
      {this.content,
      this.id,
      this.isActive,
      this.thumbnailUrl,
      this.title,
      this.subtitle,
      this.videoBlocks,
      this.duration,
      this.levelName,
      this.level,
      this.teachers,
      this.type,
      this.typeName});

  YogaOnlineLesson.fromSnapshot(DataSnapshot snapshot)
      : id = snapshot.value["id"],
        content = snapshot.value["content"],
        isActive = snapshot.value["isActive"],
        thumbnailUrl = snapshot.value["thumbnailUrl"],
        title = snapshot.value["title"],
        subtitle = snapshot.value["subtitle"],
        videoBlocks = snapshot.value["videoBlocks"],
        duration = snapshot.value["duration"],
        levelName = snapshot.value["level_name"],
        level = snapshot.value["level"],
        teachers = snapshot.value["teachers"],
        type = snapshot.value["type"],
        typeName = snapshot.value["type_name"];

//  List<Week> getWeeks() {
//    if (weeks == null || weeks.length == 0) {
//      return [];
//    }
//    return weeks.map((v) => Week.fromObject(v)).toList();
//  }
//
  List<VideoModel> getVideos() {
    if (videoBlocks == null || videoBlocks.length == 0) {
      return [];
    }
    return videoBlocks.map((video) => VideoModel.fromObject(video)).toList();
  }
}
