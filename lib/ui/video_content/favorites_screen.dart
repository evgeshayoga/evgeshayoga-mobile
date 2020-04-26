import 'package:evgeshayoga/models/yoga_online_lesson.dart';
import 'package:evgeshayoga/ui/video_content/components/yoga_online_column.dart';
import 'package:evgeshayoga/utils/check_is_landscape.dart';
import 'package:evgeshayoga/utils/style.dart';
import 'package:flutter/material.dart';

class FavoritesScreen extends StatefulWidget {
  final List favoriteVideosIds;
  final List<YogaOnlineLesson> videos;

  FavoritesScreen(this.favoriteVideosIds, this.videos, context, {Key key})
      : super(key: key);

  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<YogaOnlineLesson> videosToDisplay = [];
  bool isLandscape = false;

  @override
  void initState() {
    super.initState();
    initialize();
  }

  Future initialize() async {
    setState(() {
      videosToDisplay = widget.videos
          .where((video) => widget.favoriteVideosIds.contains(video.id))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    bool hasFavorites = widget.favoriteVideosIds.length > 0;
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
            ? videoLessons(isLandscape, videosToDisplay, context)
            : Text(
                "У нас нет избранных видео",
                style: Style.regularTextStyle,
              ),
      ),
    );
  }
}
