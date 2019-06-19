import 'package:evgeshayoga/models/program.dart';
import 'package:evgeshayoga/old_files/marathons_data.dart';
import 'package:evgeshayoga/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ProgramScreen extends StatelessWidget {
  final String programTitle;
  final int programId;


  @override
  ProgramScreen(this.programTitle, this.programId, {Key key}) : super(key: key);

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(programTitle,
          style: Style.headerTextStyle,
        ),
        backgroundColor: Style.pinkMain,
      ),
      body: Container(
        padding: const EdgeInsets.all(25),
        child: ListView(
          children: <Widget>[
            ProgramBuilder(programId),
//            Container(
//              child: ListView.builder(
//                itemCount: null,
//                itemBuilder: null,
//              ),
//            )
          ],
        ),
      ),
    );
  }
}