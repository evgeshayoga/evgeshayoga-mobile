import 'package:cached_network_image/cached_network_image.dart';
import 'package:evgeshayoga/ui/video_content/lesson_screen.dart';
import 'package:evgeshayoga/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:transparent_image/transparent_image.dart';

Widget yogaOnlineLessonCard(
    yogaOnlineLesson, isLandscape, BuildContext context) {
  ConstrainedBox programThumbnail = ConstrainedBox(
    constraints: BoxConstraints(minHeight: 100, maxHeight: 300),
    child: Container(
      alignment: Alignment.center,
      child: FadeInImage(placeholder: MemoryImage(kTransparentImage), image: CachedNetworkImageProvider("https://evgeshayoga.com" + yogaOnlineLesson.thumbnailUrl)),
    ),
  );

  Text title = Text(
    yogaOnlineLesson.title,
    textAlign: TextAlign.center,
    style: Style.headerTextStyle,
  );

  return Container(
    child: Card(
      elevation: 0,
      child: GestureDetector(
        onTap: () {
          var router = new MaterialPageRoute(builder: (BuildContext context) {
            return LessonScreen(yogaOnlineLesson.title, yogaOnlineLesson.id);
          });
          Navigator.of(context).push(router);
        },
        child: isLandscape
            ? Row(
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: <Widget>[
                        title,
                        additionalInfo(yogaOnlineLesson),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: programThumbnail,
                  )
                ],
              )
            : Column(
                children: <Widget>[
                  ListTile(title: title, subtitle: programThumbnail),
                  additionalInfo(yogaOnlineLesson),
                ],
              ),
      ),
    ),
  );
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
