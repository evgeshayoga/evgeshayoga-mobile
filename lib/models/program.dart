import 'package:evgeshayoga/models/video_model.dart';
import 'package:evgeshayoga/models/week.dart';
import 'package:firebase_database/firebase_database.dart';

class Program {
  String content;
  int id;
  bool isActive;
  String thumbnailUrl;
  String title;
  List weeks;
  List videoBlocks;

  Program(this.id,
      {this.content,
      this.isActive,
      this.thumbnailUrl,
      this.title,
      this.weeks,
      this.videoBlocks});

  Program.fromSnapshot(DataSnapshot snapshot)
      : id = snapshot.value["id"],
        content = snapshot.value["content"],
        isActive = snapshot.value["isActive"],
        thumbnailUrl = snapshot.value["thumbnailUrl"],
        title = snapshot.value["title"],
        weeks = snapshot.value["weeks"],
        videoBlocks = snapshot.value["videoBlocks"];

  List<Week> getWeeks() {
    if (weeks == null || weeks.length == 0) {
      return [];
    }
    return weeks.map((v) => Week.fromObject(v)).toList();
  }

  List<VideoModel> getVideos() {
    if (videoBlocks == null || videoBlocks.length == 0) {
      return [];
    }
    return videoBlocks.map((video) => VideoModel.fromObject(video)).toList();
  }
}
