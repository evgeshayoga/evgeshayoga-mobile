import 'package:evgeshayoga/models/user.dart';
import 'package:evgeshayoga/models/yoga_online_lesson.dart';
import 'package:evgeshayoga/ui/programs/components/drawer_content_screen.dart';
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
  User user;
  Map<String, dynamic> userSubscriptionStatus;
  bool hasAccess = false;
  String _selectedLevel;
  String _selectedType;
  String _selectedTeacher;
  String _selectedDuration;
  List<YogaOnlineLesson> videos = [];
  List videosToDisplay = [];

  @override
  void initState() {
    super.initState();
    dbVideosReference = database.reference().child("videos");
    user = User("", "", "", "");

    dbVideosReference.once().then((snapshot) {
      for (var value in snapshot.value) {
        if (value != null) {
          videos.add(YogaOnlineLesson.fromFB(value));
        }
      }
//      debugPrint(videos[1].title);
//      debugPrint(videos.toString());
//      debugPrint(videos[0]["level"].toString());
//      debugPrint("START" + snapshot.value.toString() + "END");
//    var result = videos.map((v){
//      YogaOnlineLesson.fromFB(v);
//    });
//    debugPrint(result.toString());
    });

    getUserSubscriptionStatus(widget.userUid).then((subscription) {
      setState(() {
        userSubscriptionStatus = subscription;
        hasAccess = userSubscriptionStatus['isSubscriptionActive'];
      });
    });
  }

  List<DropdownMenuItem> ddLevel() {
    List<DropdownMenuItem> ddLevels = [];
    Map levels = {};
    videos.forEach((video) {
      if (!levels.containsKey(video.level)) {
        levels[video.level] = video.levelName;
      }
    });
    var sortedKeys = levels.keys.toList()..sort();
    sortedKeys.forEach((key) {
      ddLevels.add(
        DropdownMenuItem<String>(
          value: key.toString(),
          child: Text(
            "" + levels[key],
          ),
        ),
      );
    });
    return ddLevels;
  }

  List<DropdownMenuItem> ddType() {
    List<DropdownMenuItem> ddTypes = [];
    Map types = {};
    videos.forEach((video) {
      if (!types.containsKey(video.type)) {
        types[video.type] = video.typeName;
      }
    });
//    debugPrint(types.toString());
    var keys = types.keys.toList();
//    debugPrint("keys"+keys.toString());
    keys.forEach((key) {
      ddTypes.add(
        DropdownMenuItem<String>(
          value: key.toString(),
          child: Text(
            "" + types[key],
          ),
        ),
      );
    });
    return ddTypes;
  }

  List<DropdownMenuItem> ddTeachers() {
    List<DropdownMenuItem> ddTeachers = [];
    Map teachers = {};

    videos.forEach((video) {
      video.teachers.forEach((teacher) {
        if (!teachers.containsKey(teacher["id"])) {
          teachers[teacher["id"]] = teacher["name"];
        }
      });
    });
//    debugPrint(teachers.toString());
    var keys = teachers.keys.toList()..sort();
//    debugPrint("keys"+keys.toString());

    keys.forEach((key) {
      ddTeachers.add(
        DropdownMenuItem<String>(
          value: key.toString(),
          child: Text(
            "" + teachers[key],
          ),
        ),
      );
    });
    return ddTeachers;
  }

//
//  List<DropdownMenuItem> ddDuration() {
//    List<DropdownMenuItem> ddDurations = [];
//    List durations = [];
//    videos.forEach((video){
//      if (!durations.contains(video["duration"])){
//        durations.add(video["duration"]);
//      }
//    });
//    List sorted = durations..sort();
//    sorted.forEach((element){
//      ddDurations.add(
//        DropdownMenuItem<String>(
//          value: element.toString(),
//          child: Text("" +
//              element.toString(),
//          ),
//        ),
//      );
//    });
//    return ddDurations;
//  }

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
      endDrawer: Drawer(
        child: SafeArea(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 50),
              ),
              Container(
                height: 50,
                child: Center(child: Text("Фильтры")),
              ),
              DropdownButton(
                items: ddLevel(),
                onChanged: (value) {
                  setState(() {
                    _selectedLevel = value;
                  });
//                  debugPrint(_selectedLevel);
                },
//                value: __selectedLevel,
                hint: Text(
                  "Уровень",
                ),
                value: _selectedLevel,
              ),
              DropdownButton(
                items: ddType(),
                onChanged: (value) {
                  setState(() {
                    _selectedType = value;
                  });
//                  debugPrint(__selectedType);
                },
//                value: __selectedType,
                hint: Text(
                  "Вид",
                ),
                value: _selectedType,
              ),
              DropdownButton(
                items: ddTeachers(),
                onChanged: (value) {
                  setState(() {
                    _selectedTeacher = value;
                  });
//                  debugPrint(__selectedType);
                },
//                value: __selectedType,
                hint: Text(
                  "Преподаватель",
                ),
                value: _selectedTeacher,
              ),
              DropdownButton(
                items: [
                  DropdownMenuItem<String>(
                    value: '10',
                    child: Text(
                      "10",
                    ),
                  ),
                  DropdownMenuItem<String>(
                    value: '20',
                    child: Text(
                      "20",
                    ),
                  ),
                  DropdownMenuItem<String>(
                    value: '30',
                    child: Text(
                      "30",
                    ),
                  ),
                  DropdownMenuItem<String>(
                    value: '40',
                    child: Text(
                      "40",
                    ),
                  ),
                  DropdownMenuItem<String>(
                    value: '50',
                    child: Text(
                      "50",
                    ),
                  ),
                  DropdownMenuItem<String>(
                    value: '60',
                    child: Text(
                      "60",
                    ),
                  ),
                  DropdownMenuItem<String>(
                    value: '90',
                    child: Text(
                      "90",
                    ),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedDuration = value;
                  });
//                  debugPrint(__selectedType);
                },
//                value: __selectedType,
                hint: Text(
                  "Продолжительност",
                ),
                value: _selectedDuration,
              ),
              RaisedButton(
                onPressed: () {
                  _applyFilters();
                },
                color: Style.pinkMain,
                child: new Text(
                  "Применить",
                  style: Style.regularTextStyle,
                ),
              ),
              RaisedButton(
                onPressed: () {
                  _clearFilters();
                },
                color: Style.pinkMain,
                child: new Text(
                  "Очистить",
                  style: Style.regularTextStyle,
                ),
              ),
            ],
          ),
        ),
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
    if (videos.length == 0 || videos.length == null) {
      return progressHUD();
    } else {
      List<Widget> videosColumn = [];
      videos.forEach((video) {
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

  void _applyFilters() {
    List<YogaOnlineLesson> filteredVideos = videos.map((v) => v).toList();

    if (_selectedLevel != null) {
      filteredVideos = filteredVideos
          .where((video) => video.level == int.parse(_selectedLevel))
          .toList();
    }
    if (_selectedType != null) {
      filteredVideos = filteredVideos
          .where((video) => video.type == int.parse(_selectedType))
          .toList();
    }
    setState(() {
      videosToDisplay = filteredVideos;
    });

    debugPrint(filteredVideos.length.toString());
    Navigator.of(context).pop();
// teacher, duration, type, accent, level
  }

  void _clearFilters() {
    setState(() {
      _selectedDuration = null;
      _selectedLevel = null;
      _selectedTeacher = null;
      _selectedType = null;
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
                  Icons.hourglass_empty,
                  size: 16,
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
