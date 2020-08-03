import 'package:evgeshayoga/ui/video_content/components/yoga_online_lesson_card.dart';
import 'package:flutter/material.dart';

Widget videoLessons(isLandscape, videosToDisplay, BuildContext context, favoriteVideosIds) {
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
        videosColumn.add(YogaOnlineLessonCard(yogaOnlineLesson: video, isLandscape: isLandscape, favoriteVideosIds: favoriteVideosIds));
      }
    });

    return ListView.builder(
      itemCount: videosColumn.length,
      itemBuilder: (context, i) => videosColumn[i],
    );
  }
}