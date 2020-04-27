import 'package:evgeshayoga/models/video.dart';
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
  int format;
  String formatName;

  YogaOnlineLesson();

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
        typeName = value["type_name"],
        format = value["format"] ?? 0,
        formatName = value["format_name"] ?? "";

  List<VideoModel> getVideos() {
    if (videoBlocks == null || videoBlocks.length == 0) {
      return [];
    }
    return videoBlocks.map((video) => VideoModel.fromObject(video)).toList();
  }
}
