import 'package:evgeshayoga/models/video_model.dart';
import 'package:firebase_database/firebase_database.dart';

class Week {
  String content;
  String thumbnailUrl;
  String title;
  List videoBlocks;

  Week({this.content, this.thumbnailUrl, this.title, this.videoBlocks});

  Week.fromObject(dynamic value)
      : content = value["content"],
        thumbnailUrl = value["thumbnailUrl"],
        title = value["title"],
        videoBlocks = value["videoBlocks"];

  List<VideoModel> getVideos() {
    if (videoBlocks == null || videoBlocks.length == 0) {
      return [];
    }
    return videoBlocks.map((video) => VideoModel.fromObject(video)).toList();
  }
}