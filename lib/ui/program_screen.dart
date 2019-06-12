import 'package:evgeshayoga/old_files/marathons_data.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ProgramScreen extends StatelessWidget {
  final Map program;


  @override

  ProgramScreen(this.program, {Key key}) : super(key: key);

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          program["title"],
          style: TextStyle(
            fontFamily: "GarageGothic",
            fontSize: 30,
            color: Color.fromRGBO(94, 101, 111, 1),
          ),
        ),
        backgroundColor: Color.fromRGBO(242, 206, 210, 1),
      ),
      body: Container(
        padding: const EdgeInsets.all(25),
        child: ListView(
          children: <Widget>[
            Container(
              child: Text(program["content"]),
            ),
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