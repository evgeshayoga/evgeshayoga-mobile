import 'package:evgeshayoga/utils/style.dart';
import 'package:flutter/material.dart';
import 'components/lesson_builder.dart';

class LessonScreen extends StatelessWidget {
  final String lessonTitle;
  final int lessonId;
  @override
  LessonScreen(this.lessonTitle, this.lessonId, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return BackButton(
              color: Style.blueGrey,
            );
          },
        ),
        centerTitle: true,
        title: Text(lessonTitle,
          style: Style.titleTextStyle,
        ),
        backgroundColor: Style.pinkMain,
      ),
      body: LessonBuilder(lessonId)
    );
  }
}

