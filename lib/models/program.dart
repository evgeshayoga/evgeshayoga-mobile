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

  ProgramBuilder(Key key, this.id) : super(key: key);

  @override
  _ProgramBuilderState createState() => _ProgramBuilderState();
}

class _ProgramBuilderState extends State<ProgramBuilder> {
  final FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference dbProgramsReference;
  Program program;

  @override
  void initState() {
    super.initState();
    dbProgramsReference = database.reference().child("marathons");
    program = Program(widget.id);
  }

  Widget build(BuildContext context) {
    return Text("");
  }
}

_getSelectedProgram(id, snapshot) {
  Program selectedProgram;
  List<Program> allPrograms = snapshot["marathons"];
  selectedProgram = allPrograms.singleWhere((item) {
    return item.id == id;
  });
  print(selectedProgram);
}
