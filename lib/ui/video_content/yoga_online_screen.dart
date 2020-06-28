import 'package:evgeshayoga/models/user.dart';
import 'package:evgeshayoga/models/yoga_online_lesson.dart';
import 'package:evgeshayoga/ui/video_content/favorites_screen.dart';
import 'package:evgeshayoga/ui/video_content/components/drawer_content_screen.dart';
import 'package:evgeshayoga/ui/video_content/components/filters_drawer.dart';
import 'package:evgeshayoga/ui/video_content/components/yoga_online_column.dart';
import 'package:evgeshayoga/utils/ProgressHUD.dart';
import 'package:evgeshayoga/utils/check_is_landscape.dart';
import 'package:evgeshayoga/utils/getUserSubscriptionStatus.dart';
import 'package:evgeshayoga/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:package_info/package_info.dart';


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
  List favoriteVideosIds = [];
  bool hasAccess = false;
  Filters _filters = Filters();
  List<YogaOnlineLesson> videos = [];
  List<YogaOnlineLesson> videosToDisplay = [];
  bool _isInAsyncCall = true;
  String version = '';
  String buildNumber = '';

  @override
  void initState() {
    super.initState();
    initialize();
  }

  Future initialize() async {
    dbVideosReference = database.reference().child("videos");
    dbUsersReference =
        database.reference().child("users").child(widget.userUid);

    List<YogaOnlineLesson> videosFromFB = [];
    User decodedUser;
    try {
      var userSnapshot = await dbUsersReference.once();
      var videosSnapshot = await dbVideosReference.once();
      decodedUser = User.fromSnapshot(userSnapshot);
      for (var value in videosSnapshot.value) {
        if (value != null) {
          videosFromFB.add(YogaOnlineLesson.fromFB(value));
        }
      }
    } on DatabaseError catch (e) {
      Navigator.pushReplacementNamed(context, "/home");
      return;
    }

    videosFromFB.sort((sa, sb) {
      return sb.id - sa.id;
    });
    var subscription = await getUserSubscriptionStatus(widget.userUid);
    setState(() {
      userSubscriptionStatus = subscription;
      hasAccess = userSubscriptionStatus['isSubscriptionActive'];
      _isInAsyncCall = false;
      videosToDisplay = videosFromFB;
      user = decodedUser;
      videos = videosFromFB;
      favoriteVideosIds = userSubscriptionStatus['favourite'];
    });

    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      setState(() {
        version = packageInfo.version;
        buildNumber = packageInfo.buildNumber;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isLandscape = checkIsLandscape(context);
    return Scaffold(
      drawer: drawerProgramScreen(user, context, widget.userUid, isLandscape, version, buildNumber),
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
            Builder(
              builder: (context) => IconButton(
                icon: Icon(
                  Icons.favorite_border,
                  size: 26.0,
                  color: Style.blueGrey,
                ),
                onPressed: () {

                  var router = new MaterialPageRoute(builder: (BuildContext context) {
                    return FavoritesScreen(widget.userUid, videos, context);
                  });
                  Navigator.of(context).push(router);
                },
              ),
            ),
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
    if (_isInAsyncCall) {
      return progressHUD(
        _isInAsyncCall,
      );
    } else
      return hasAccess
          ? videoLessons(widget.userUid, isLandscape, videosToDisplay, context, favoriteVideosIds)
          : Center(
              child: Text('Вы не подписаны на Yoga Online'),
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
    if (filters.format != null) {
      filteredVideos = filteredVideos
          .where((video) => video.format == int.parse(filters.format))
          .toList();
    }
    setState(() {
      _filters = filters;
      videosToDisplay = filteredVideos;
    });
    Navigator.of(context).pop();
  }

  void _clearFilters() {
    setState(() {
      _filters = Filters();
      videosToDisplay = videos;
    });
  }
}
