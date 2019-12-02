import 'package:evgeshayoga/models/user.dart';
import 'package:evgeshayoga/models/yoga_online_lesson.dart';
import 'package:evgeshayoga/ui/programs/lesson_screen.dart';
import 'package:evgeshayoga/utils/ProgressHUD.dart';
import 'package:evgeshayoga/utils/style.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
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
//      debugPrint(widget.userUid);
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
//      Container(
//      child: Center(
//        child: Text('Coming soon...'),
//      ),
//    );
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
//      height: MediaQuery.of(context).size.height -80,
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
//                    Text(
//                      "Доступен до " + dateFormatted(date),
//                      style: Style.regularTextStyle,
//                    ),
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
//              Padding(
//                padding: const EdgeInsets.all(12.0),
//                child: Text(
//                  "Доступен до " + dateFormatted(date),
//                  style: Style.regularTextStyle,
//                ),
//              )
                  ],
                ),
        ),
      ),
    );
  }
}

Future<Map<String, dynamic>> getUserSubscriptionStatus(String uid) async {
//  debugPrint(uid);
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
