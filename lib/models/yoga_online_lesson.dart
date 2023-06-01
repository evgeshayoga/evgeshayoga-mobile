import 'package:evgeshayoga/models/video.dart';

class YogaOnlineLesson {
  final String content;
  final int id;
  final  bool isActive;
  final  String thumbnailUrl;
  final  String title;
  final  String subtitle;
  final  List videoBlocks;
  final int duration;
  final String levelName;
  final int level;
  final List teachers;
  final List categories;
  final int type;
  final String typeName;
  final int format;
  final String formatName;

  YogaOnlineLesson.fromFB(Map<String, dynamic> value)
      : id = value["id"],
        content = value["content"],
        isActive = value["isActive"],
        thumbnailUrl = value["thumbnailUrl"],
        title = value["title"],
        subtitle = value["subtitle"],
        videoBlocks = value["videoBlocks"] ?? [],
        duration = value["duration"],
        levelName = value["level_name"],
        level = value["level"],
        teachers = value["teachers"] ?? [],
        categories = value["categories"] ?? [],
        type = value["type"],
        typeName = value["type_name"],
        format = value["format"] ?? 0,
        formatName = value["format_name"] ?? "";

  List<VideoModel> getVideos() {
    if (videoBlocks.length == 0) {
      return [];
    }
    return videoBlocks.map((video) => VideoModel.fromObject(video)).toList();
  }
}
