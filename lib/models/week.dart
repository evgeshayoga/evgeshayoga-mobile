import 'package:evgeshayoga/models/video.dart';

class Week {
  final String content;
  final String thumbnailUrl;
  final String title;
  final List videoBlocks;

  Week.fromObject(Map value)
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