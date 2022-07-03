import 'package:evgeshayoga/models/video.dart';
import 'package:evgeshayoga/models/week.dart';
import 'package:firebase_database/firebase_database.dart';

class Program {
  late String content;
  late int id;
  late bool isActive;
  late String thumbnailUrl;
  late String title;
  late List weeks;
  late List videoBlocks;

  Program.fromSnapshot(DataSnapshot snapshot) {
    var data = new Map<String, dynamic>.from(snapshot.value as dynamic);
    id = data["id"];
    content = data["content"];
    isActive = data["isActive"];
    thumbnailUrl = data["thumbnailUrl"];
    title = data["title"];
    weeks = data["weeks"] ?? [];
    videoBlocks = data["videoBlocks"] ?? [];
  }

  List<Week> getWeeks() {
    if (weeks.length == 0) {
      return [];
    }
    return weeks.map((v) => Week.fromObject(v)).toList();
  }

  List<VideoModel> getVideos() {
    if (videoBlocks.length == 0) {
      return [];
    }
    return videoBlocks.map((video) => VideoModel.fromObject(video)).toList();
  }
}
