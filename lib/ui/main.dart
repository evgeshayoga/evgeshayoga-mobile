import 'package:evgeshayoga/utils/animator.dart';
import 'package:evgeshayoga/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:evgeshayoga/ui/login.dart';


void main() {
  runApp(MaterialApp(
      theme: ThemeData(
          primaryColor: Style.pinkMain,
          textTheme: TextTheme(
              headline: Style.titleTextStyle,
              title: Style.headerTextStyle,
              body1: Style.regularTextStyle,
              body2: Style.regularTextStyle
          )
      ),
      debugShowCheckedModeBanner: false,
      title: "Йога с Женей",
      initialRoute: '/',
      home: new HomeAnimator(),
      ));
}