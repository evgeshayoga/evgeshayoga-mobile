import 'package:evgeshayoga/models/program.dart';
import 'package:evgeshayoga/models/video_model.dart';
import 'package:evgeshayoga/old_files/video.dart';
import 'package:evgeshayoga/ui/programs/chewie_player.dart';
import 'package:evgeshayoga/ui/programs/week_screen.dart';
import 'package:evgeshayoga/utils/style.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class ProgramBuilder extends StatefulWidget {
  int id;

  ProgramBuilder(this.id, {Key key}) : super(key: key);

  @override
  _ProgramBuilderState createState() => _ProgramBuilderState();
}

class _ProgramBuilderState extends State<ProgramBuilder> {
  final FirebaseDatabase database = FirebaseDatabase.instance;
  Program program;
  List<VideoModel> videos = [];

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
        videos = program.getVideos();
      });
    });
  }

  Widget build(BuildContext context) {
    if (program == null) {
      return Container(
        height: 300,
        child: ModalProgressHUD(
          color: Colors.transparent,
          progressIndicator: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Style.pinkMain),
          ),
          inAsyncCall: true,
//          opacity: 1,
          child: Text(
            "Загружается...",
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
    List<Widget> programWeeks = [];
    program.getWeeks().forEach((week) {
      programWeeks.add(Container(
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Style.blueGrey.withOpacity(0.3),
              blurRadius: 3,
            )
          ],
        ),
        child: ListTile(
          title: Text(
            week.title,
            style: Style.headerTextStyle,
            textAlign: TextAlign.center,
          ),
          subtitle:
              Image.network("https://evgeshayoga.com" + week.thumbnailUrl),
          onTap: () {
            var router = new MaterialPageRoute(builder: (BuildContext context) {
              return WeekScreen(week);
            });
            Navigator.of(context).push(router);
          },
        ),
      ));
    });

    List<Widget> videoBlocks = [];
    videos.forEach((video) {
      videoBlocks.add(Container(
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Style.blueGrey.withOpacity(0.3),
              blurRadius: 3,
            )
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            title: Text(
              video.title + ". " + video.subtitle,
              style: Style.titleTextStyle,
            ),
            subtitle: Column(
              children: <Widget>[
                ChewieVideo(video.hls),
                video.content == null
                    ? null
                    : Text(
                        video.content,
                        style: Style.regularTextStyle,
                      ),
//              Padding(padding: const EdgeInsets.only(bottom: 8.0))
//              Divider(
//                color: Style.blueGrey,
//              )
              ],
            ),
          ),
        ),
      ));
    });

    return Column(
      children: <Widget>[
        Column(
          children: <Widget>[
            DefaultTextStyle(
              child: HtmlWidget(
                program.content,
                webView: true,
              ),
              style: Theme.of(context).textTheme.body1,
            )
          ],
        ),
        Column(
          children: programWeeks,
        ),
        Column(children: videoBlocks),
      ],
    );
  }
}
