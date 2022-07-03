import 'package:evgeshayoga/models/yoga_online_lesson.dart';
import 'package:evgeshayoga/ui/video_content/favorites_screen.dart';
import 'package:evgeshayoga/ui/video_content/components/drawer_content_screen.dart';
import 'package:evgeshayoga/ui/video_content/components/filters_drawer.dart';
import 'package:evgeshayoga/ui/video_content/components/yoga_online_column.dart';
import 'package:evgeshayoga/utils/ProgressHUD.dart';
import 'package:evgeshayoga/utils/check_is_landscape.dart';
import 'package:evgeshayoga/utils/getUserAccessStatus.dart';
import 'package:evgeshayoga/utils/style.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:firebase_database/firebase_database.dart';

class YogaOnlineScreen extends StatefulWidget {
  final String userUid;

  YogaOnlineScreen({Key? key, required this.userUid}) : super(key: key);

  @override
  _YogaOnlineScreenState createState() => _YogaOnlineScreenState();
}

class _YogaOnlineScreenState extends State<YogaOnlineScreen> {
  final FirebaseDatabase database = FirebaseDatabase.instance;
  final DatabaseReference dbVideosReference = FirebaseDatabase.instance.reference().child("videos");
  DatabaseReference? dbUsersReference;
  Map<String, dynamic> userSubscriptionStatus = new Map();
  List favoriteVideosIds = [];
  bool hasAccess = false;
  Filters _filters = Filters();
  List<YogaOnlineLesson> videos = [];
  List<YogaOnlineLesson> videosToDisplay = [];
  bool _isInAsyncCall = true;

  @override
  void initState() {
    super.initState();
    initialize();
  }

  Future initialize() async {

    List<YogaOnlineLesson> videosFromFB = [];
    try {
      var videosSnapshot = await dbVideosReference.once();
      var value = videosSnapshot.snapshot.value as List<Object?>;
      value.forEach((v) {
        if (v != null) {
          videosFromFB.add(YogaOnlineLesson.fromFB(Map<String, dynamic>.from(v as dynamic)));
        }
      });
    } on FirebaseException {
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
      videos = videosFromFB;
      favoriteVideosIds = userSubscriptionStatus['favourite'];
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isLandscape = checkIsLandscape(context);
    return Scaffold(
      drawer: drawerProgramScreen(isLandscape),
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
          actions: getAppBarActions()),
      body: yogaOnlineBody(isLandscape),
    );
  }

  List<Widget> getAppBarActions() {
    if (!hasAccess || _isInAsyncCall) {
      return [filterButton()];
    }
    return [
      Builder(
        builder: (context) => IconButton(
          icon: Icon(
            Icons.favorite_border,
            size: 26.0,
            color: Style.blueGrey,
          ),
          onPressed: () {
            var router = new MaterialPageRoute(builder: (BuildContext context) {
              return FavoritesScreen(videos, context);
            });
            var nav = Navigator.of(context);
            nav.push(router);
          },
        ),
      ),
      filterButton()
    ];
  }

  Widget filterButton() {
    return Builder(
      builder: (context) => IconButton(
        icon: Icon(
          AntDesign.filter,
          size: 26.0,
          color: Style.blueGrey,
        ),
        onPressed: () => _isInAsyncCall ? () => {} : Scaffold.of(context).openEndDrawer(),
      ),
    );
  }

  Widget yogaOnlineBody(isLandscape) {
    if (_isInAsyncCall) {
      return progressHUD(
        _isInAsyncCall,
      );
    } else
      return hasAccess
          ? videoLessons(
              isLandscape, videosToDisplay, context, favoriteVideosIds)
          : Center(
              child: Text('Вы не подписаны на Yoga Online'),
            );
  }

  void _applyFilters(Filters filters) {
    List<YogaOnlineLesson> filteredVideos = videos.map((v) => v).toList();

    if (filters.level != null) {
      filteredVideos = filteredVideos
          .where((video) => video.level == int.parse(filters.level!))
          .toList();
    }
    if (filters.type != null) {
      filteredVideos = filteredVideos
          .where((video) => video.type == int.parse(filters.type!))
          .toList();
    }
    if (filters.teacher != null) {
      filteredVideos = filteredVideos
          .where((video) =>
              video.teachers.any((t) => t["id"] == int.parse(filters.teacher!)))
          .toList();
    }
    if (filters.category != null) {
      filteredVideos = filteredVideos
          .where((video) => video.categories
              .any((cat) => cat["id"] == int.parse(filters.category!)))
          .toList();
    }
    if (filters.duration != null) {
      filteredVideos = filteredVideos
          .where((video) =>
              int.parse(filters.duration!) - 5 <= video.duration &&
              video.duration <= int.parse(filters.duration!) + 4)
          .toList();
    }
    if (filters.format != null) {
      filteredVideos = filteredVideos
          .where((video) => video.format == int.parse(filters.format!))
          .toList();
    }
    setState(() {
      _filters = filters;
      videosToDisplay = filteredVideos;
    });
    var nav = Navigator.of(context);
    nav.pop();
  }

  void _clearFilters() {
    setState(() {
      _filters = Filters();
      videosToDisplay = videos;
    });
  }
}
