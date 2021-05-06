import 'package:evgeshayoga/models/yoga_online_lesson.dart';
import 'package:evgeshayoga/provider/user_provider_model.dart';
import 'package:evgeshayoga/ui/video_content/components/yoga_online_column.dart';
import 'package:evgeshayoga/utils/ProgressHUD.dart';
import 'package:evgeshayoga/utils/check_is_landscape.dart';
import 'package:evgeshayoga/utils/getUserAccessStatus.dart';
import 'package:evgeshayoga/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoritesScreen extends StatefulWidget {
  final List<YogaOnlineLesson> videos;

  FavoritesScreen(this.videos, context, {Key? key}) : super(key: key);

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
    String? userUid =
        Provider.of<UserProviderModel>(context, listen: false).userUid;
    setState(() {
      _isInAsyncCall = true;
    });

    getUserSubscriptionStatus(userUid!).then((status) {
      setState(() {
        userSubscriptionStatus = status;
        bool hasAccess = userSubscriptionStatus['isSubscriptionActive'];
        if (hasAccess) {
          favoriteVideosIds = userSubscriptionStatus['favourite'];
          videosToDisplay = widget.videos
              .where((video) => favoriteVideosIds.contains(video.id))
              .toList();
        }
        _isInAsyncCall = false;
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
    bool isLandscape = checkIsLandscape(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Избранное",
          style: Style.titleTextStyle,
        ),
        centerTitle: true,
        backgroundColor: Style.pinkMain,
      ),
      body: _isInAsyncCall
          ? progressHUD(_isInAsyncCall)
          : Center(
              child: hasFavorites
                  ? videoLessons(
                      isLandscape, videosToDisplay, context, favoriteVideosIds)
                  : Text(
                      "У нас нет избранных видео",
                      style: Style.regularTextStyle,
                    ),
            ),
    );
  }
}
