import 'package:evgeshayoga/models/yoga_online_lesson.dart';
import 'package:evgeshayoga/ui/video_content/components/yoga_online_column.dart';
import 'package:evgeshayoga/utils/check_is_landscape.dart';
import 'package:evgeshayoga/utils/getUserSubscriptionStatus.dart';
import 'package:evgeshayoga/utils/style.dart';
import 'package:flutter/material.dart';

class FavoritesScreen extends StatefulWidget {
  final String uid;
//  final List favoriteVideosIds;
  final List<YogaOnlineLesson> videos;

  FavoritesScreen(this.uid, this.videos, context, {Key key})
      : super(key: key);

  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List favoriteVideosIds = [];
  List<YogaOnlineLesson> videosToDisplay = [];
  Map<String, dynamic> userSubscriptionStatus = {};
  bool isLandscape = false;
  bool _isInAsyncCall = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      _isInAsyncCall = true;
    });

    getUserSubscriptionStatus(widget.uid).then((status) {
      setState(() {
        userSubscriptionStatus = status;
        favoriteVideosIds = userSubscriptionStatus['favourite'];
        _isInAsyncCall = false;
        videosToDisplay = widget.videos
            .where((video) => favoriteVideosIds.contains(video.id))
            .toList();
      });
    });
  }

  Future initialize() async {
    setState(() {
      videosToDisplay = widget.videos
          .where((video) => favoriteVideosIds.contains(video.id))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    bool hasFavorites = favoriteVideosIds.length > 0;
    isLandscape = checkIsLandscape(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Избранное",
          style: Style.titleTextStyle,
        ),
        centerTitle: true,
        backgroundColor: Style.pinkMain,
      ),
      body: Center(
        child: hasFavorites
            ? videoLessons(widget.uid, isLandscape, videosToDisplay, context, favoriteVideosIds)
            : Text(
                "У нас нет избранных видео",
                style: Style.regularTextStyle,
              ),
      ),
    );
  }
}
