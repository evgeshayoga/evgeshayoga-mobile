import 'package:evgeshayoga/utils/animator.dart';
import 'package:flutter/material.dart';
import 'package:evgeshayoga/ui/login.dart';


void main() {
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Йога с Женей",
      initialRoute: '/',
      home: new HomeAnimator(),
      ));
}