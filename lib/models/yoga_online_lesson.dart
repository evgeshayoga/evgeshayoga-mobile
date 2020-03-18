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
  List categories;
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
      this.categories,
      this.type,
      this.typeName});

  YogaOnlineLesson.fromFB(value)
      : id = value["id"],
        content = value["content"],
        isActive = value["isActive"],
        thumbnailUrl = value["thumbnailUrl"],
        title = value["title"],
        subtitle = value["subtitle"],
        videoBlocks = value["videoBlocks"],
        duration = value["duration"],
        levelName = value["level_name"],
        level = value["level"],
        teachers = value["teachers"],
        categories = value["categories"],
        type = value["type"],
        typeName = value["type_name"];

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
