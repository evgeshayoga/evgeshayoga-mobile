import 'package:evgeshayoga/models/week.dart';
import 'package:firebase_database/firebase_database.dart';

class Program {
  String content;
  int id;
  bool isActive;
  String thumbnailUrl;
  String title;
  List weeks;

  Program(this.id,
      {this.content, this.isActive, this.thumbnailUrl, this.title, this.weeks});

  Program.fromSnapshot(DataSnapshot snapshot)
      : id = snapshot.value["id"],
        content = snapshot.value["content"],
        isActive = snapshot.value["isActive"],
        thumbnailUrl = snapshot.value["thumbnailUrl"],
        title = snapshot.value["title"],
        weeks = snapshot.value["weeks"];

  List<Week> getWeeks() {
    if(weeks == null || weeks.length == 0) {
      return [];
    }
    return weeks.map((v) => Week.fromObject(v)).toList();
  }
}


