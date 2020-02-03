import 'package:evgeshayoga/models/user.dart';
import 'package:evgeshayoga/models/yoga_online_lesson.dart';
import 'package:evgeshayoga/ui/programs/lesson_screen.dart';
import 'package:evgeshayoga/utils/ProgressHUD.dart';
import 'package:evgeshayoga/utils/style.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';

class YogaOnline extends StatefulWidget {
  final String userUid;

  YogaOnline({Key key, this.userUid}) : super(key: key);

  @override
  _YogaOnlineState createState() => _YogaOnlineState();
}

class _YogaOnlineState extends State<YogaOnline> {
  static const int tabletBreakpoint = 600;
  final FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference dbVideosReference;
  User user;
  Map<String, dynamic> userSubscriptionStatus;
  bool hasAccess = false;

  @override
  void initState() {
    super.initState();
    dbVideosReference = database.reference().child("videos");
    user = User("", "", "", "");

    getUserSubscriptionStatus(widget.userUid).then((subscription) {
      setState(() {
        userSubscriptionStatus = subscription;
        hasAccess = userSubscriptionStatus['isSubscriptionActive'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var shortestSide = MediaQuery.of(context).size.shortestSide;
    var orientation = MediaQuery.of(context).orientation;
    var isLandscape = true;
    if (orientation == Orientation.portrait &&
        shortestSide < tabletBreakpoint) {
      isLandscape = false;
    }

    if (userSubscriptionStatus == null) {
      return progressHUD();
    } else
      return hasAccess
          ? videoLessons(isLandscape)
          : Center(
              child: Text('Вы не подписаны на Yoga Online'),
            );
  }

  Widget videoLessons(isLandscape) {
    return Column(
      children: <Widget>[
        Flexible(
          child: FirebaseAnimatedList(
              query: dbVideosReference,
              itemBuilder: (_, DataSnapshot snapshot,
                  Animation<double> animation, int index) {
                var yogaOnlineLesson = YogaOnlineLesson.fromSnapshot(snapshot);

                if (snapshot == null || userSubscriptionStatus == null) {
                  return progressHUD();
                }

                if (!yogaOnlineLesson.isActive) {
                  return Container();
                }
                return _yogaOnlineLessonCard(yogaOnlineLesson, isLandscape);
              }),
        )
      ],
    );
  }

  Widget _yogaOnlineLessonCard(yogaOnlineLesson, isLandscape) {
    ConstrainedBox programThumbnail = ConstrainedBox(
      constraints: BoxConstraints(minHeight: 100, maxHeight: 300),
      child: Container(
        alignment: Alignment.center,
        child: Image.network(
          "https://evgeshayoga.com" + yogaOnlineLesson.thumbnailUrl,
        ),
      ),
    );

    Text title = Text(
      yogaOnlineLesson.title,
      textAlign: TextAlign.center,
      style: Style.headerTextStyle,
    );

    return Container(
      child: Card(
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
}

Widget additionalInfo(yogaOnlineLesson){
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
//                    Text(" " +
//                      yogaOnlineLesson.id.toString(),
//                      style: Style.regularTextStyle,
//                    ),
            Row(
              children: <Widget>[
                Icon(
                  Icons.hourglass_empty,
                  size: 16,
                ),
                Text(": " +
                    yogaOnlineLesson.duration.toString() +
                    " мин"),
              ],
            ),
          ],
        ),
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
  teachersList.forEach((teacher) {
    teachersStr += ' ' + (teacher["name"]);
  });
  return teachersStr;
}

Widget levelIcon(level) {
  Icon ic;
  switch (level) {
    case 0:
      {
        ic = Icon(MaterialCommunityIcons.signal_cellular_1, color: Style.blueGrey,);
      }
      break;
    case 1:
      {
        ic = Icon(MaterialCommunityIcons.signal_cellular_2, color: Style.blueGrey);
      }
      break;
    case 2:
      {
        ic = Icon(MaterialCommunityIcons.signal_cellular_3, color: Style.blueGrey);
      }
      break;
  }
  return ic;
}

Future<Map<String, dynamic>> getUserSubscriptionStatus(String uid) async {
  var response = await http.get(
    "https://evgeshayoga.com/api/users/" + uid + "/videos",
  );
  Map<String, dynamic> data = json.decode(response.body);
  String error = data["error"];
  if (error != null) {
    throw new Exception(error);
  }
  return data;
}
