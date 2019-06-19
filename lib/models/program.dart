import 'package:evgeshayoga/utils/style.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
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
}

class ProgramBuilder extends StatefulWidget {
  int id;

  ProgramBuilder(this.id, {Key key}) : super(key: key);

  @override
  _ProgramBuilderState createState() => _ProgramBuilderState();
}

class _ProgramBuilderState extends State<ProgramBuilder> {
  final FirebaseDatabase database = FirebaseDatabase.instance;
  Program program;

  @override
  void initState() {
    super.initState();
    database
        .reference()
        .child("marathons")
        .child('${widget.id}')
        .once()
        .then((snapshot) {
      setState(() {
        program = Program.fromSnapshot(snapshot);
      });
    });
  }

  Widget build(BuildContext context) {
    if (program == null) {
      return Text("Loading");
    }
    return Text(program.content, style: Style.regularTextStyle,);
  }
}
