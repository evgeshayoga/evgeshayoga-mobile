import 'package:evgeshayoga/models/video.dart';

class Week {
  String content;
  String thumbnailUrl;
  String title;
  List videoBlocks;

  Week.fromObject(dynamic value)
      : content = value["content"] ?? "",
        thumbnailUrl = value["thumbnailUrl"] ?? "",
        title = value["title"] ?? "",
        videoBlocks = value["videoBlocks"] ?? [];

  List<VideoModel> getVideos() {
    if (videoBlocks.length == 0) {
      return [];
    }
    return videoBlocks.map((video) => VideoModel.fromObject(video)).toList();
  }
}