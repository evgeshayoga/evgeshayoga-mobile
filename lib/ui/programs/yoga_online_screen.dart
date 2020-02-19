import 'package:evgeshayoga/models/user.dart';
import 'package:evgeshayoga/models/yoga_online_lesson.dart';
import 'package:evgeshayoga/ui/programs/components/drawer_content_screen.dart';
import 'package:evgeshayoga/ui/programs/components/filters_drawer.dart';
import 'package:evgeshayoga/ui/programs/lesson_screen.dart';
import 'package:evgeshayoga/utils/ProgressHUD.dart';
import 'package:evgeshayoga/utils/style.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';

class YogaOnlineScreen extends StatefulWidget {
  final String userUid;

  YogaOnlineScreen({Key key, this.userUid}) : super(key: key);

  @override
  _YogaOnlineScreenState createState() => _YogaOnlineScreenState();
}

class _YogaOnlineScreenState extends State<YogaOnlineScreen> {
  static const int tabletBreakpoint = 600;
  final FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference dbVideosReference;
  DatabaseReference dbUsersReference;
  User user = User("", "", "", "");
  Map<String, dynamic> userSubscriptionStatus;
  bool hasAccess = false;
  Filters _filters = Filters();
  List<YogaOnlineLesson> videos = [];
  List videosToDisplay = [];
  bool _isInAsyncCall = true;

  @override
  void initState() {
    super.initState();
    initialize();
  }

  Future initialize() async {
    dbVideosReference = database.reference().child("videos");
    dbUsersReference =
        database.reference().child("users").child(widget.userUid);

    var userSnapshot = await dbUsersReference.once();
    var videosSnapshot = await dbVideosReference.once();
    List<YogaOnlineLesson> videosFromFB = [];
    for (var value in videosSnapshot.value) {
      if (value != null) {
        videosFromFB.add(YogaOnlineLesson.fromFB(value));
        videosFromFB.sort((sa, sb) {
          return sb.id - sa.id;
        });
      }
    }

    var subscription = await getUserSubscriptionStatus(widget.userUid);
    setState(() {
      userSubscriptionStatus = subscription;
      hasAccess = userSubscriptionStatus['isSubscriptionActive'];
      _isInAsyncCall = false;
      videosToDisplay = videosFromFB;
      user = User.fromSnapshot(userSnapshot);
      videos = videosFromFB;
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
    return Scaffold(
      drawer: drawerProgramScreen(user, context, widget.userUid, isLandscape),
      endDrawer: FiltersDrawer(
        videos: videos,
        filters: _filters,
        onApplyFilters: _applyFilters,
        onClear: _clearFilters,
      ),
      appBar: AppBar(
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(
                  Icons.menu,
                  color: Colors.blueGrey,
                ),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              );
            },
          ),
          title: Image.asset(
            'assets/images/logo_white.png',
            alignment: Alignment.centerLeft,
            fit: BoxFit.contain,
            repeat: ImageRepeat.noRepeat,
            height: 30,
          ),
          centerTitle: true,
          backgroundColor: Style.pinkMain,
          actions: [
//            Builder(
//              builder: (context) => IconButton(
//                icon: Icon(
//                  Icons.search,
//                  size: 26.0,
//                  color: Style.blueGrey,
//                ),
//                onPressed: () {},
//              ),
//            ),
            Builder(
              builder: (context) => IconButton(
                icon: Icon(
                  AntDesign.filter,
                  size: 26.0,
                  color: Style.blueGrey,
                ),
                onPressed: () => Scaffold.of(context).openEndDrawer(),
              ),
            ),
          ]),
      body: yogaOnlineBody(isLandscape),
    );
  }

  Widget yogaOnlineBody(isLandscape) {
//    if (userSubscriptionStatus == null) {
//      return Text("empty status");
//    }
    if (_isInAsyncCall) {
      return progressHUD(
        _isInAsyncCall,
      );
    } else
      return hasAccess
          ? videoLessons(isLandscape)
          : Center(
              child: Text('Вы не подписаны на Yoga Online'),
            );
  }

  Widget videoLessons(isLandscape) {
//    if (videos.length == 0 || videos.length == null) {
//      return Container(
//        child: Text("No videos"),
//      );
//    }
    if (videosToDisplay.length == 0) {
      return Center(
        child: Text("НЕТ ЗАПИСЕЙ"),
      );
    } else {
      List<Widget> videosColumn = [];
      videosToDisplay.forEach((video) {
        if (!video.isActive) {
          videosColumn.add(Container());
        } else {
          videosColumn.add(_yogaOnlineLessonCard(video, isLandscape));
        }
      });

      return ListView(
        children: <Widget>[
          Column(
            children: videosColumn,
          ),
        ],
      );
    }
    return Column(
      children: <Widget>[
        Flexible(
          child: FirebaseAnimatedList(
              query: dbVideosReference,
              itemBuilder: (_, DataSnapshot snapshot,
                  Animation<double> animation, int index) {
                var yogaOnlineLesson = YogaOnlineLesson.fromSnapshot(snapshot);
                videos.add(yogaOnlineLesson);

                if (snapshot == null || userSubscriptionStatus == null) {
//                  return progressHUD();
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

  void _applyFilters(Filters filters) {
    List<YogaOnlineLesson> filteredVideos = videos.map((v) => v).toList();

    if (filters.level != null) {
      filteredVideos = filteredVideos
          .where((video) => video.level == int.parse(filters.level))
          .toList();
    }
    if (filters.type != null) {
      filteredVideos = filteredVideos
          .where((video) => video.type == int.parse(filters.type))
          .toList();
    }
    if (filters.teacher != null) {
      filteredVideos = filteredVideos
          .where((video) =>
              video.teachers.any((t) => t["id"] == int.parse(filters.teacher)))
          .toList();
    }
    if (filters.category != null) {
      filteredVideos = filteredVideos
          .where((video) => video.categories
              .any((cat) => cat["id"] == int.parse(filters.category)))
          .toList();
    }
    if (filters.duration != null) {
      filteredVideos = filteredVideos
          .where((video) =>
              int.parse(filters.duration) - 5 <= video.duration &&
              video.duration <= int.parse(filters.duration) + 4)
          .toList();
    }
    setState(() {
      _filters = filters;
      videosToDisplay = filteredVideos;
    });

//    debugPrint(filteredVideos.length.toString());
//    debugPrint(filteredVideos[0].id.toString());
    Navigator.of(context).pop();
// teacher, duration, type, accent, level
  }

  void _clearFilters() {
    setState(() {
      _filters = Filters();
      videosToDisplay = videos;
    });
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
//                    Text(" " +
//                      yogaOnlineLesson.id.toString(),
//                      style: Style.regularTextStyle,
//                    ),
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

//        Row(
//          children: <Widget>[
//            Icon(
//              Icons.accessibility_new,
//              size: 16,
//            ),
//          ],
//        ),
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
//      categoriesStr += (category["title"]) + ", ";
  });

//  if (categoriesList.length > 1) {
//    categoriesList.forEach((category) {
//      titleList.add(category["title"]);
////      categoriesStr += (category["title"]) + ", ";
//    });
//  } else {
//    categoriesStr = categoriesList[0]["title"].toString();
//  }

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
