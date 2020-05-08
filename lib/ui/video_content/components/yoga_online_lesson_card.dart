import 'package:cached_network_image/cached_network_image.dart';
import 'package:evgeshayoga/ui/video_content/lesson_screen.dart';
import 'package:evgeshayoga/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart' show PlatformException;

class YogaOnlineLessonCard extends StatefulWidget {

  String uid;
  dynamic yogaOnlineLesson;
  bool isLandscape;
  List favoriteVideosIds;

  YogaOnlineLessonCard({this.uid, this.yogaOnlineLesson, this.isLandscape, this.favoriteVideosIds});

  @override
  _YogaOnlineLessonCardState createState() => _YogaOnlineLessonCardState();
}

class _YogaOnlineLessonCardState extends State<YogaOnlineLessonCard> {

  bool isLiked = false;

  @override
  void initState() {
    super.initState();
    isLiked = widget.favoriteVideosIds.contains(widget.yogaOnlineLesson.id);
  }

  Widget addToFavoritesButton(uid, videoId) {
    return FlatButton(
      onPressed: (){
        onAddtoFavorites(uid, videoId);
      },
      color: Colors.white,
      splashColor: Style.pinkMain,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(isLiked ? Icons.favorite : Icons.favorite_border, color: Style.pinkMain,),
          Text(isLiked ? '   Удалить из избранного' : '   Добавить в избранное', style: Style.regularTextStyle,)
        ],
      ),
    );
  }

  Future onAddtoFavorites(uid, videoId) async {
    try {
      var response = await http.post("https://evgeshayoga.com/api/users/$uid/videos/$videoId/like");
      print(response.body);
      setState(() {
        isLiked = !isLiked;
      });
    } on PlatformException catch (e) {
      print("platform exception");
      print(e.toString());
    }
  }

  Widget additionalInfo(yogaOnlineLesson) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8.0, 16, 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(
                    yogaOnlineLesson.levelName + "  ",
                    style: Style.regularTextStyle,
                  ),
                  levelIcon(yogaOnlineLesson.level),
                ],
              ),
              formatIcon(yogaOnlineLesson.format),
              Row(
                children: <Widget>[
                  Icon(
                    Icons.hourglass_full,
                    size: 16,
                    color: Style.blueGrey,
                  ),
                  Text(": " + yogaOnlineLesson.duration.toString() + " мин"),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 4.0, 16, 4.0),
          child: Text("Акцент: " + categories(yogaOnlineLesson.categories),
              textAlign: TextAlign.center),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(teachers(yogaOnlineLesson.teachers)),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    ConstrainedBox programThumbnail = ConstrainedBox(
      constraints: BoxConstraints(minHeight: 100, maxHeight: 300),
      child: Container(
        alignment: Alignment.center,
        child: FadeInImage(placeholder: MemoryImage(kTransparentImage), image: CachedNetworkImageProvider("https://evgeshayoga.com" + widget.yogaOnlineLesson.thumbnailUrl)),
      ),
    );
    Text title = Text(
      widget.yogaOnlineLesson.title,
      textAlign: TextAlign.center,
      style: Style.headerTextStyle,
    );
    return Container(
      child: Card(
        elevation: 0,
        child: GestureDetector(
          onTap: () {
            var router = new MaterialPageRoute(builder: (BuildContext context) {
              return LessonScreen(widget.yogaOnlineLesson.title, widget.yogaOnlineLesson.id);
            });
            Navigator.of(context).push(router);
          },
          child: widget.isLandscape
              ? Row(
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Column(
                  children: <Widget>[
                    title,
                    additionalInfo(widget.yogaOnlineLesson),
                    addToFavoritesButton(widget.uid, widget.yogaOnlineLesson.id),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: programThumbnail,
              )
            ],
          )
              : Column(
            children: <Widget>[
              ListTile(title: title, subtitle: programThumbnail),
              additionalInfo(widget.yogaOnlineLesson),
              addToFavoritesButton(widget.uid, widget.yogaOnlineLesson.id),
            ],
          ),
        ),
      ),
    );
  }
}

String teachers(teachersList) {
  String teachersStr = '';
  List namesList = [];
  teachersList.forEach((teacher) {
    namesList.add(teacher["name"]);
  });
  return teachersStr = namesList.join(', ');
}

String categories(categoriesList) {
  String categoriesStr = '';
  List titleList = [];
  categoriesList.forEach((category) {
    titleList.add(category["title"]);
  });
  return categoriesStr = titleList.join(", ");
}

Widget levelIcon(level) {
  Icon ic;
  switch (level) {
    case 0:
      {
        ic = Icon(
          MaterialCommunityIcons.signal_cellular_1,
          color: Style.blueGrey,
        );
      }
      break;
    case 1:
      {
        ic = Icon(MaterialCommunityIcons.signal_cellular_2,
            color: Style.blueGrey);
      }
      break;
    case 2:
      {
        ic = Icon(MaterialCommunityIcons.signal_cellular_3,
            color: Style.blueGrey);
      }
      break;
  }
  return ic;
}

Widget formatIcon(format) {
  Icon ic;
  switch (format) {
    case 0:
      {
        ic = Icon(Icons.crop_original,
          color: Style.blueGrey,
        );
      }
      break;
    case 1:
      {
        ic = Icon(Icons.filter,
          color: Style.blueGrey,
        );
      }
      break;
  }
  return ic;
}