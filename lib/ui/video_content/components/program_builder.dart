import 'package:cached_network_image/cached_network_image.dart';
import 'package:evgeshayoga/models/program.dart';
import 'package:evgeshayoga/models/video.dart';
import 'package:evgeshayoga/ui/video_content/components/video_blocks_column.dart';
import 'package:evgeshayoga/ui/video_content/week_screen.dart';
import 'package:evgeshayoga/utils/ProgressHUD.dart';
import 'package:evgeshayoga/utils/style.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:transparent_image/transparent_image.dart';

class ProgramBuilder extends StatefulWidget {
  int id;

  ProgramBuilder(this.id, {Key? key}) : super(key: key);

  @override
  _ProgramBuilderState createState() => _ProgramBuilderState();
}

class _ProgramBuilderState extends State<ProgramBuilder> {
  final FirebaseDatabase database = FirebaseDatabase.instance;
  Program? program;
  List<VideoModel> videos = [];
  bool _isInAsyncCall = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      _isInAsyncCall = true;
    });
    database
        .ref("marathons")
        .child('${widget.id}')
        .once()
        .then((event) {
      setState(() {
        program = Program.fromSnapshot(event.snapshot);
        videos = program!.getVideos();
        _isInAsyncCall = false;
      });
    });
  }

  Widget build(BuildContext context) {
    if (program == null) {
      return Container(height: 300, child: progressHUD(_isInAsyncCall));
    }
    List<Widget> programWeeks = [];
    program!.getWeeks().forEach((week) {
      String imagePath = week.thumbnailUrl.isNotEmpty
          ? week.thumbnailUrl
          : program!.thumbnailUrl;
      programWeeks.add(Card(
        margin: EdgeInsets.all(8),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(vertical: 8),
          title: Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text(
              week.title,
              style: Style.headerTextStyle,
              textAlign: TextAlign.center,
            ),
          ),
          subtitle: FadeInImage(
              placeholder: MemoryImage(kTransparentImage),
              image: CachedNetworkImageProvider(
                  "https://evgeshayoga.com" + imagePath)),
          onTap: () {
            var router = new MaterialPageRoute(builder: (BuildContext context) {
              return WeekScreen(week);
            });
            Navigator.of(context).push(router);
          },
        ),
      ));
    });

    return Column(
      children: <Widget>[
        Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: DefaultTextStyle(
              child: HtmlWidget(
                program!.content,
                webView: true,
              ),
              style: Style.regularTextStyle,
              textAlign: TextAlign.justify,
            )),
        Column(
          children: programWeeks,
        ),
        VideoBlocks(videos),
      ],
    );
  }
}
